# 与上游的关系及同步方式

## 基线

| 项 | 值 |
| --- | --- |
| 上游仓库 | https://github.com/LeonChrome/XinHeLianSheng-Pro2-Bridge |
| 基线提交 | `d5917690c86b0824b6cceb23f35c8af2a16ba65f`（2026-11-03） |
| 上游固件版本 | V5.9.2 |
| 分离日期 | 2026-11-10 |
| 许可证 | Apache-2.0（沿用上游） |

## 文件映射

路径在本仓库与上游保持一致，因此上游的固件改动可以直接落位，无需改脚本。

| 本仓库 | 上游对应路径 |
| --- | --- |
| `firmware/esp32s3_switch2_bridge/` | 同名 |
| `firmware/esp32s3_dualsense_identity_experiment/` | 同名 |
| `tools/esp32s3/` | 同名 |
| `tools/setup_dev_environment.ps1` | 同名 |
| `tools/build_all.ps1` | 同名（本仓库删掉 `-Package` 分支） |
| `tools/tests/gamepad_axis_math_test.c` 等 | 同名 |
| `docs/DEVELOPMENT_ENVIRONMENT.md` 等四篇 | 同名 |

注意：上游 `source/final-three-in-one/firmware/` 下另有一份**较旧的**固件快照（含 `ble_dual_probe`、`xbox_paddle_mapper` 等未合入主线的实验文件）。同步时一律以 `firmware/` 顶层为准，不要用那份快照反向覆盖。

## 拉取上游固件改动

```bash
git remote add upstream https://github.com/LeonChrome/XinHeLianSheng-Pro2-Bridge.git
git fetch upstream

# 只看固件相关提交
git log --oneline upstream/main -- firmware tools/esp32s3 docs

# 拣选单个提交
git cherry-pick <sha>

# 或直接取某条路径的最新版本
git checkout upstream/main -- firmware/esp32s3_switch2_bridge
```

拣选后必须重新编译验证：

```powershell
.\tools\esp32s3\build.ps1
.\tools\build_all.ps1
```

## 上游若停止维护

上游已把重心转向纯软件方案，`firmware/` 可能长期不再变动。此后本仓库即事实主线：固件 bug、ESP-IDF 版本升级、新主机兼容性都在这里推进，`UPSTREAM.md` 的基线信息保留作为来源记录。
