# Changelog

本仓库只记录 **ESP32-S3 固件** 的变更。Windows 上位机的历史版本见上游
[XinHeLianSheng-Pro2-Bridge](https://github.com/LeonChrome/XinHeLianSheng-Pro2-Bridge) 的 `CHANGELOG.md`。

## 0.1.0 · 2026-11-10 · 独立仓库首次发布

从上游 `d591769`（2026-11-03，固件 V5.9.2）分离出的固件专用仓库。

### 纳入

- `firmware/esp32s3_switch2_bridge`：Pro2 / Nintendo 与 Xbox / XInput 双 profile 主固件
- `firmware/esp32s3_dualsense_identity_experiment`：DualSense 身份 + UAC1 4ch 触觉音频实验分支
- `tools/esp32s3/*`：build / flash / monitor / erase / 端口探测 / 短路径补丁
- `tools/setup_dev_environment.ps1`：项目内自包含的 ESP-IDF v5.4.2 + Python 3.11 + esp32s3 工具集
- `tools/build_all.ps1`：一次编完四个 profile
- `tools/tests/`：`gamepad_axis_math`、`pro2_rumble_arbiter` 两个纯 C 单元测试
- 相关文档：开发环境、技术要点、故障排查、HD 震动稳定性测试计划

### 剔除

- Windows Manager / V55 Manager / 控制中心等 .NET 上位机
- Pico2W 无线桥、VIIPER / USBIP 纯软件链路、第三方 vendored 源码
- `release/` 下的 EXE 发布包与主机侧抓包工具
- 只服务于上位机打包流程的脚本（`package_v5_9_manager.ps1`、`run_profile_mode_lock_tests.ps1` 等）

### 改动

- `tools/build_all.ps1` 去掉 `-Package` 分支（原分支调用上位移机打包脚本）
- 新增 GitHub Actions：三个 profile 交叉编译校验
- 新增 `README.md`、`UPSTREAM.md`，原上游 README / 发布说明不再随仓库携带

### 继承自上游 V5.9.2 的固件行为

- 三种用户可见模式统一为 新和联胜 / PS5、Pro2 / Nintendo、Xbox / XInput
- 新增首次配对、重连已保存手柄、更换手柄的引导流程
- 新增通用 `ble forget` 命令，安全清除已保存的 BLE 目标
- 手柄休眠或瞬时断链后仍自动重连，USB 手柄接口保持在线
- 全部固件版本上报统一为 V5.9.2
- 状态兼容：同时接受 `live_*` 与 PS5 风格 `input_*` 新鲜度字段
