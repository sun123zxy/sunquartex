# SunQuarTex

基于 Quarto 的自用中英文学术写作模板库．

支持输出至 HTML、PDF/LaTeX、Beamer、MS Word、Github Flavored Markdown (GFM) 等多种格式，覆盖交叉引用、插图绘制、定理系统等多种功能．

## Usage

请先安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)．测试 Quarto 版本为 1.4.550．

- `quarto render index-cnart.qmd`
- `quarto render index-enart.qmd`
- `quarto render index-cnpre.qmd`
- `quarto render index-enpre.qmd`

`--to` 参数可指定输出类型，包括 `html`, `pdf`， `beamer`, `docx`, `gfm`．每次渲染时应指定 `--to` 参数，或在文档中明确指定输出格式．

在文件中声明 `lang=zh` 或 `lang=en` 即可调整语言．

### 关于 TikZ / tikzcd

HTML / PDF / Beamer 格式现已支持 TikZ！请确保 XeLaTeX 和 dvisvgm 已在 path 中（大部分 LaTeX 发行版均有内置）．在 Beamer 中使用时，所在幻灯片须添加 `{.fragile}` 标记．

若文档中包含 Mermaid、Graphviz 等 diagram 且需输出 PDF，请确保已安装 Chrome 或 Chromium．若无，可使用 `quarto install tool chromium` 安装．（参见 [Quarto - Diagrams # Chrome Install](https://quarto.org/docs/authoring/diagrams.html#chrome-install)）

### 关于 PDF/LaTeX

需要输出 PDF 时，请确保已安装 Quarto 支持的 LaTeX 发行版．若无，可使用 `quarto install tool tinytex` 安装．

可在输出 PDF 前自行对 LaTeX 文件（`*.tex`）做进一步修正，再自行使用 `xelatex` 和 `biber` 输出 PDF．

## 若干说明

### 关于引用格式

默认全部使用 IEEE 格式．如需修改，请自定义 `sun*****.cls` 和 `_format.yml`．

### 关于标题

一般文档建议从二级标题开始编号（[相关讨论](https://community.rstudio.com/t/why-do-default-r-markdown-quarto-templates-use-second-level-headings-instead-of-first-level-ones/162127)）；Beamer 的 `slide-level` 可自适应标题级数，但其分节固定从一级标题开始，见 Pandoc 文档．

### 关于 Beamer

理论上与文档格式兼容，可直接设置 `--to=pdf` 输出文稿版本．

### 关于 GFM

尽管开启了 `wrap: preserve`，生成的 markdown 文件的换行行为仍可能不尽人意．这里是一些基于（vscode 查找 / 替换）正则表达式替换的后期补救措施：

- `(</span>)\s*\$\$` 替换为 `$1\n$$$$`：用于在定理紧邻 display math 时强制换行．

- 考虑去除部分 HTML 标签（如`<div>`, `<span>`）

  `<div(([\s\S])*?)>` 替换为空．
  
  `</div>` 替换为空．

- `\n\n\n` 替换为 `\n\n`：删除多余空行．

注意：这一方案未对代码块做特殊处理．

## Known Issues

- 见 [Discussion #4598](https://github.com/quarto-dev/quarto-cli/discussions/4598)，Pandoc 不支持 CSL-M 导致无有效方法处理 GB/T 7714-2015 中按语言切换“等”、`et al` 省略字样的规定．

- 【need-repro】表格与代码混排有时会使位置发生偏移，页面下部的代码块可能会溢出．

- 通用的定理编号目前尚难以自定义，见 [Discussion #5479](https://github.com/quarto-dev/quarto-cli/discussions/5479)

- HTML 子图图像拉伸问题，似乎是因为没有设置 `height: auto`，有空去发个 issue．

## Planning Enhancements

- 考虑支持 `callthm` 和 `tikz` 独立为插件．