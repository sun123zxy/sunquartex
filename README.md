# SunQuarTex

基于 Quarto 的自用中文学术写作模板库．

支持输出至 HTML、PDF/LaTeX、MS Word 等多种格式，覆盖交叉引用、插图绘制、定理系统等多种功能．

现已支持中文 Beamer 输出．

## Usage

请先安装 [quarto-cli](https://github.com/quarto-dev/quarto-cli)．测试 Quarto 版本为 1.3.340．

- `quarto render index-cnart.qmd --profile=cn,art,cnart`
- `quarto render index-enart.qmd --profile=en,art,enart`
- `quarto render index-cnpre.qmd --profile=cn,pre,cnpre`

请注意，`freeze` 功能可能已生效，为确保表格、图片等得到重新渲染，可能需要显式指定渲染文件．如成功运行，文件将输出至 `/output/` 文件夹下．

一般文档建议从二级标题开始编号（[相关讨论](https://community.rstudio.com/t/why-do-default-r-markdown-quarto-templates-use-second-level-headings-instead-of-first-level-ones/162127)）；Beamer 的 `slide-level` 可自适应标题级数，但其分节固定从一级标题开始，见 Pandoc 文档．

### 关于 PDF/LaTeX

需要输出 PDF 时，请确保已安装 Quarto 支持的 LaTeX 发行版．若无，可使用 `quarto install tool tinytex` 安装．

可在输出 PDF 前自行对 LaTeX 文件（`*.tex`）做进一步修正，再自行使用 `tex2pdf.bat` 输出 PDF．

若文档中包含 Mermaid、Graphviz 等 diagram 且需输出 PDF，请确保已安装 Chrome 或 Chromium．若无，可使用 `quarto install tool chromium` 安装．（参见 [Quarto - Diagrams # Chrome Install](https://quarto.org/docs/authoring/diagrams.html#chrome-install)）

### 关于 Beamer

理论上与文档格式兼容，使用 `art` 编译即可方便地输出文稿版本．

## Known Issues

- PDF / MS Word 中的 Graphviz 图像可能拉伸变形，设置合适的 `fig-height` 和 `fig-width` 可解决问题．其它 figure 同样可能遇到此问题．
  
  目前 PDF 格式中的问题应该已经修复．

- PDF 中的 Mermaid/Graphviz diagram 的 `figure` 环境在 LaTeX 中出现嵌套问题，导致自定义模板的元素定位出现异常．见 [Issue #3736](https://github.com/quarto-dev/quarto-cli/issues/3736)．

- 同时输出 HTML 和 LaTeX 时二者的 `index_files` 会发生冲突．

- 见 [Discussion #4598](https://github.com/quarto-dev/quarto-cli/discussions/4598)，Pandoc 不支持 CSL-M 导致无有效方法处理 GB/T 7714-2015 中按语言切换“等”、`et al` 省略字样的规定．

- 表格与代码混排有时会使位置发生偏移，页面下部的代码块可能会溢出．

- 通用的定理编号目前尚难以自定义，见 [Discussion #5479](https://github.com/quarto-dev/quarto-cli/discussions/5479)

- 目前对 HTML 格式下定理的 Callout 化比较粗糙，对 CSS 直接操作，引用、脚注放置于侧边栏时会导致格式错乱。Quarto 1.4 应会对定理系统生成的结构有所改进，届时可做调整。此外，见 [Issue #7158](https://github.com/quarto-dev/quarto-cli/issues/7158)，标题里的脚注也存在格式问题。

- TODO：在 yaml 中开启目录

- TODO：使用 yaml 的 `lang` 控制模板语言本地化

- TODO：PDF 格式 `cnart` 和 `enart` 的 `date-modified` 功能