# SunQuarTeX

基于 Quarto 的自用中英文学术写作模板库．支持输出至 HTML、PDF/LaTeX、Beamer、MS Word、GFM 等多种格式，覆盖交叉引用、插图绘制、定理系统等多种功能．

- [仓库主页](https://github.com/sun123zxy/sunquartex)
- [网页 Demo](https://sun123zxy.github.io/sunquartex)

## 核心功能

- 基于 Pandoc's Markdown 的完备学术写作语法
- 强大的交叉引用与定理系统功能
- HTML、PDF/LaTeX、Beamer、MS Word、Github Flavored Markdown (GFM) 全格式输出
- 嵌入 Python 代码生成数据图表（Computation）
- TikZ / [tikz-cd](https://ctan.org/pkg/tikz-cd) / [quiver](https://q.uiver.app/) 图表绘制
- Mermaid、Graphviz 图表绘制（Diagram）
- Github Actions 自动生成 Demo 站点
- ...

## 安装

安装方法简述如下，另可参见本仓库下的 Github Actions 配置文件．

- 下载并安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)．测试 Quarto 版本为 1.6.39.

- （需要使用 Computation 等功能时）
  
  安装恰当版本的 Python 和所需模块，如 jupyter、numpy、matplotlib、tabulate 等．

- （需要输出 LaTeX / PDF / Beamer 时）
  
  请确保已安装 Quarto 支持的 LaTeX 发行版．若无，可使用 `quarto install tinytex --update-path` 安装．

- （需要使用 Mermaid、Graphviz 等 Diagram 功能且需输出 PDF）

  请确保已安装 Chrome 或 Chromium．若无，可使用 `quarto install tool chromium` 安装．（参见 [Quarto - Diagrams # Chrome Install](https://quarto.org/docs/authoring/diagrams.html#chrome-install)）

- （需要在非 LaTeX / PDF / Beamer 格式下（如 HTML）输出 TikZ 时）

  请确保 XeLaTeX、dvisvgm、mutool 已在 PATH 中，且已安装需要使用的 LaTeX 宏包（目前 TikZ 中使用的宏包无法在渲染过程中自动安装）．

  - 如使用 Quarto 自带的 TinyTeX：
  
    - 先输出一次 PDF 自动补全大部分所需宏包
    - 执行 `tlmgr install dvisvgm` 和 `tlmgr path add` 下载 dvisvgm 并添加至 PATH．
    - Linux 执行 `sudo apt install mupdf-tools`．

  - 关于 mutool 必要性的一些说明：

    > As of Ghostscript 10.01.0, this will no longer work due to the introduction of a new PDF interpreter. Therefore, an alternative conversion module based on mutool, a utility which is part of the MuPDF package, has been introduced. It’s automatically invoked if Ghostscript can’t be used and if a working mutool executable is present in a directory which is part of the system’s search path.
    > 
    > 来自 [dvisvgm manual](https://dvisvgm.de/Manpage/)

## Usage

部分示例文件包含可选支持内容，如未安装相应依赖，可删除对应内容后渲染．

- `quarto render index-cnart.qmd`
- `quarto render index-enart.qmd`
- `quarto render index-cnpre.qmd`
- `quarto render index-enpre.qmd`

`--to` 参数可指定输出类型，包括 `html`, `pdf`， `beamer`, `docx`, `gfm`．每次渲染时应指定 `--to` 参数，或在文件头中明确指定输出格式．

在文件头声明 `lang=zh` 或 `lang=en` 即可调整语言．

输出 PDF 时，可在渲染时使用 `--to=latex` 选项输出 `.tex` 文件．

在 Beamer 中使用 TikZ 时，所在幻灯片须添加 `{.fragile}` 标记．

## FAQ

### 关于定理编号

Quarto 内置的定理编号系统无法修改，但我们提供通过 YAML 文档头自定义 PDF 格式定理编号的可能，示例见 `_format.yml`．

### 关于引用格式

PDF / Beamer 输出使用 BibLaTeX alphabetical，HTML 输出使用 IEEE．如需修改，请自定义 `sun*****.cls` 和 `_format.yml` 和 CSL 文件．

### 关于标题

一般文档建议从二级标题开始编号（[相关讨论](https://community.rstudio.com/t/why-do-default-r-markdown-quarto-templates-use-second-level-headings-instead-of-first-level-ones/162127)）；Beamer 的 `slide-level` 可自适应标题级数，但其分节固定从一级标题开始，见 Pandoc 文档．

### 关于 Beamer

理论上与文档格式兼容，可直接设置 `--to=pdf` 输出文稿版本．

支持使用 YAML 文档头自定义部分颜色，示例见 `_format.yml`．

### 关于 GFM

该输出格式可用于使用 [markdown.com.cn](https://markdown.com.cn/editor/) 的在线编辑器转知乎格式．

### 关于 Demo 站点

本仓库同时采用 Github Actions + Github Pages 自动生成 Demo 站点．首次使用时，在 Actions 分页中激活 Actions，在本地手动进行第一次网站发布：

- 命令行内设置环境变量 `QUARTO_PROFILE` 为 `website`
- 执行 `quarto publish`
- （清除环境变量）

以后的每次 push 均会触发 Github Actions 自动完成的网站生成．

如需自定义网站域名，请在根目录下添加 CNAME 文件，并修改 `_quarto-website.yml` 下 `site-url`．

## Known Issues

- 见 [Discussion #4598](https://github.com/quarto-dev/quarto-cli/discussions/4598)，Pandoc 不支持 CSL-M 导致无有效方法处理 GB/T 7714-2015 中按语言切换“等”、`et al` 省略字样的规定．

- 通用的定理编号目前尚难以自定义，见 [Discussion #5479](https://github.com/quarto-dev/quarto-cli/discussions/5479)

- HTML 子图图像拉伸问题，似乎是因为没有设置 `height: auto`，有空去发个 issue．

- 2025/04/15 定理标题中的文献引用导致 LaTeX 中出现嵌套中括号，见 [Issue #12584](https://github.com/quarto-dev/quarto-cli/issues/12584)

- 2025/06/29 目前 RST-style list tables 的 row-span 在 PDF 格式下支持不良．

- 2025/06/29 网站生成的 PDF 没有设置 base URL，相对链接无法正确解析．见 [Discussion #13000](https://github.com/quarto-dev/quarto-cli/discussions/13000)