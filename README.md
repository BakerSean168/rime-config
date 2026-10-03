# Rime configuration

本仓库保存个人的小狼毫（Weasel）与雾凇拼音（rime-ice）覆盖配置；不包含雾凇拼音本体和自动生成的学习数据。

## 文件

- `default.custom.yaml`：雾凇全拼、候选数与中英文切换规则。
- `weasel.custom.yaml`：小狼毫候选框样式，以及 Windows Terminal / Neovim 的英文优先设置。
- `custom_phrase.txt`：个人短语。此仓库为私有仓库时可直接记录；如要改为公开仓库，请先移除敏感信息。

## Windows 同步

1. 安装小狼毫与雾凇拼音本体。
2. 在 PowerShell 中运行仓库自带的安装器：

```powershell
.\install.ps1
```

安装器只管理 `default.custom.yaml`、`weasel.custom.yaml` 和 `custom_phrase.txt`：它们会被复制到 `%AppData%\Rime`，随后自动查找已安装的小狼毫 `WeaselDeployer.exe` 并执行 `/deploy`。不会删除学习数据、雾凇拼音本体或其他 Rime 文件。

如只需要同步文件而暂不重新部署：

```powershell
.\install.ps1 -SkipDeploy
```

若小狼毫安装在非标准目录，可显式传入：

```powershell
.\install.ps1 -WeaselDeployer 'D:\Apps\Rime\weasel-x.y.z\WeaselDeployer.exe'
```

## 约定

- 不提交 `*.userdb`、`*.bin` 或 `build/`：它们是机器生成的学习/部署数据。
- 更新雾凇拼音时，更新上游文件后重新部署；本仓库中的 `*.custom.yaml` 保持不变。
