# Rime configuration

本仓库保存个人的小狼毫（Weasel）与雾凇拼音（rime-ice）覆盖配置；不包含雾凇拼音本体和自动生成的学习数据。

## 文件

- `default.custom.yaml`：雾凇全拼、候选数与中英文切换规则。
- `weasel.custom.yaml`：小狼毫候选框样式，以及 Windows Terminal / Neovim 的英文优先设置。
- `custom_phrase.txt`：个人短语。此仓库为私有仓库时可直接记录；如要改为公开仓库，请先移除敏感信息。

## Windows 同步

1. 安装小狼毫与雾凇拼音本体。
2. 将本仓库中的三个配置文件复制到 `%AppData%\Rime`。
3. 右键小狼毫状态图标，选择“重新部署”。

```powershell
Copy-Item .\default.custom.yaml, .\weasel.custom.yaml, .\custom_phrase.txt "$env:APPDATA\Rime" -Force
& 'C:\Program Files\Rime\weasel-0.17.4\WeaselDeployer.exe' /deploy
```

## 约定

- 不提交 `*.userdb`、`*.bin` 或 `build/`：它们是机器生成的学习/部署数据。
- 更新雾凇拼音时，更新上游文件后重新部署；本仓库中的 `*.custom.yaml` 保持不变。
