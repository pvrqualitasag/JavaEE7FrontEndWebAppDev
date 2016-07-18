### # setting the path
setwd("C:/Daten/GitHub/pvrqualitasag/JavaEE7FrontEndWebAppDev/vignettes/JEE7FEWADevPracSummary")
### # insertOdgAsPdf
psOdgFileStem = "NewCss"
psOdgDir = "odg"
psFigOutDir = "."
sPdfFilename <- paste(psOdgFileStem, "pdf", sep = ".")
sPdfFile <- file.path(psFigOutDir,sPdfFilename)
sOdgFilename <- paste(psOdgFileStem, "odg", sep = ".")
sOdgFile <- file.path(psOdgDir, sOdgFilename)


### # convertLibOToPdf
psLibOFile = sOdgFilename
psLibODir = psOdgDir
psFigOutDir = psFigOutDir
sOdgDir <- psLibODir
sOdgDirWin <- gsub("/", "\\", sOdgDir, fixed = TRUE)
sConvCmdStem <- ifelse(.Platform$OS.type == "windows",
                        '"C:/Program Files (x86)/LibreOffice 5/program/soffice" --headless --convert-to pdf',
                        "soffice --headless --convert-to pdf")
sFigFile <- ifelse(.Platform$OS.type == "windows",
                    paste(sOdgDirWin, psLibOFile, sep = "\\"),
                    file.path(sOdgDir, psLibOFile))
!file.exists(sFigFile)


rmddochelper::create_odg_graphic(psGraphicName = file.path(sOdgDir, psLibOFile))




### # create_odg_graphic
psGraphicName = file.path(sOdgDir, psLibOFile)
psOdgDir       = "odg"
psOdgTemplate  = "odg_figure"
psTemplatePkg  = "rmddochelper"


### # rmd_draft
file        = psGraphicName
template    = psOdgTemplate
package     = psTemplatePkg
create_dir  = "default"
pbOverwrite = FALSE
plReplace   = NULL

if (!is.null(package)) {
  template_path = system.file("rmarkdown", "templates",
                              template, package = package)
  if (!nzchar(template_path)) {
    stop("The template '", template, "' was not found in the ",
         package, " package")
  }
} else {
  template_path <- template
}

template_yaml <- file.path(template_path, "template.yaml")
if (!file.exists(template_yaml)) {
  stop("No template.yaml file found for template '", template,
       "'")
}

template_meta <- rmarkdown:::yaml_load_file_utf8(template_yaml)
if (is.null(template_meta$name) || is.null(template_meta$description)) {
  stop("template.yaml must contain name and description fields")
}

if (identical(create_dir, "default"))
  create_dir <- isTRUE(template_meta$create_dir)
if (create_dir) {
  file <- tools::file_path_sans_ext(file)
  if (dir.exists(file))
    stop("The directory '", file, "' already exists.")
  dir.create(file, recursive = TRUE)
  file <- file.path(file, basename(file))
}

if (!identical(tolower(tools::file_ext(file)), "rmd"))
  file <- paste(file, ".Rmd", sep = "")
if (file.exists(file))
  stop("The file '", file, "' already exists.")


