# Switch Pro2 ESP

Nintendo Switch 2 Pro（Pro2）手柄 → ESP32-S3 无线转 USB 桥的固件工程。

本仓库是 [XinHeLianSheng-Pro2-Bridge](https://github.com/LeonChrome/XinHeLianSheng-Pro2-Bridge) 中 **ESP32-S3 固件部分** 的独立分支，由社区继续维护。上游已把重心转向纯软件（Windows 蓝牙直连）方案，Windows 上位机与本仓库无关。

> English：Standalone ESP32-S3 firmware for the Pro2 controller bridge, split from the upstream all-in-one repo and maintained here. The Windows manager app is **not** part of this repository.

## 它做什么

ESP32-S3 作为 BLE 主机连接真实 Pro2 手柄，同时通过原生 USB / OTG 口对主机（Windows / Steam）暴露一个 USB 游戏手柄。四种输出身份可选：

| Profile ID | 输出身份 | 说明 |
| --- | --- | --- |
| `pro2_bridge_v5_5` | Pro2 / Nintendo HID `057E:2069` | 64 字节 HID 输入报告 `0x05`，MI_01 WinUSB |
| `xinput_bridge_v5_8` | Xbox / XInput `045E:028E` | 普通强弱震动转 Pro2 BLE 输出 |
| `hid_audio_uac1_4ch_ds5like` | 新和联胜 / PS5 兼容 HID + UAC1 4ch | HD 触觉音频通道 |
| `hid_only` | 纯 HID 恢复档 | 出问题时的最小固件 |

Profile ID 沿用上游历史命名，目的是与既有上位机设置兼容，不代表当前版本号。

## 硬件

- ESP32-S3 N16R8：16 MB flash + 8 MB Octal PSRAM
- 原生 USB / OTG 口 → 主机看到的游戏手柄
- CH343P / WCH USB 串口 → 烧录、日志、BLE 控制命令（日常使用可拔掉）
- 一块能跑 ESP-IDF 的 Windows / Linux / macOS 开发机

## 目录结构

```text
firmware/
  esp32s3_switch2_bridge/                 主固件（Pro2 / XInput 双 profile 同一份源码）
  esp32s3_dualsense_identity_experiment/  DualSense 身份 + UAC1 触觉音频实验分支
tools/
  setup_dev_environment.ps1               一次装好 .toolchain/ 内的 ESP-IDF v5.4.2 + 工具链
  build_all.ps1                           一次编完四个 profile
  esp32s3/                                单独 build / flash / monitor / erase / 端口探测
  tests/                                  纯 C 单元测试（axis math、rumble arbiter），走 MSVC
docs/                                     环境、技术要点、故障排查、HD 震动稳定性测试计划
```

## 快速开始

```powershell
# 1) 一次性准备：ESP-IDF v5.4.2 + Python 3.11 + esp32s3 工具集，全部落在 .toolchain/
.\tools\setup_dev_environment.ps1

# 2) 编译（默认 Pro2 profile）
.\tools\esp32s3\build.ps1

# 3) 编译全部四个 profile
.\tools\build_all.ps1

# 4) 烧录（CH343P 口）
.\tools\esp32s3\flash.ps1 -Port COM54

# 5) 看日志 / 发控制命令
.\tools\esp32s3\monitor.ps1
.\tools\esp32s3\send_command.ps1
```

XInput profile：

```powershell
.\tools\esp32s3\build.ps1 -BuildDir work\b\xinput -DeviceDefaultMode XINPUT_EXPERIMENT_MODE
```

脚本按仓库相对路径解析（`firmware\...`、`work\...`），克隆到任意目录都能用；Windows 上会自动用 `subst` 映射一个短盘符绕开 ESP-IDF 的路径长度限制。

更多细节见 [docs/DEVELOPMENT_ENVIRONMENT.md](docs/DEVELOPMENT_ENVIRONMENT.md)、[docs/TECHNICAL_NOTES.md](docs/TECHNICAL_NOTES.md)、[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)。

## 与上游的关系

- 基线：上游提交 `d591769`（2026-11-03），固件版本 V5.9.2
- 只保留固件与固件工具链；Windows Manager、Pico2W、VIIPER 纯软件链路、发布包均未带入
- 上游固件更新可按 [UPSTREAM.md](UPSTREAM.md) 的方式 cherry-pick 回来
- 许可证沿用上游 Apache-2.0，见 [LICENSE](LICENSE) 与 [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md)

## 现状与边界

固件功能以稳定运行为主，不为未实现的能力背书：

- 无线耳机音频转发、BLE → 多主机转发尚未实现
- PS5 触觉是转换输出，不承诺与 DualSense 物理一致
- HD 震动的稳定性结论见 [docs/HD_RUMBLE_STABILITY_TEST_PLAN.md](docs/HD_RUMBLE_STABILITY_TEST_PLAN.md)

本仓库与 Nintendo、Sony、Microsoft、Valve、Espressif、WCH 均无关联。
