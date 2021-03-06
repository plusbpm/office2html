// Generated by CoffeeScript 1.8.0
var DocxType, PdfType, UnoconvType, fs;

fs = require("fs");

PdfType = require("./pdftype");

DocxType = require("./docxtype");

UnoconvType = require("./unoconvtype");

module.exports = function(srcfile, destfile, options, cb) {
  var cnv, ext, result;
  if (!srcfile) {
    return cb("Не указан файл источник");
  }
  if (typeof options === "function") {
    cb = options;
    options = null;
  }
  if (typeof destfile === "function") {
    cb = destfile;
    destfile = null;
  }
  if (!cb) {
    return "Не указана функция возврата (callback)";
  }
  ext = srcfile.split(".").pop().toLowerCase();
  switch (ext) {
    case "pdf":
      cnv = new PdfType(srcfile, destfile);
      break;
    case "docx":
      cnv = new DocxType(srcfile, destfile);
      break;
    case "doc":
    case "odt":
    case "xls":
    case "xlsx":
    case "ods":
    case "ppt":
    case "pptx":
      cnv = new UnoconvType(srcfile, destfile);
      break;
    default:
      return cb("Неподдерживаемый тип, или не указано расширение у файла.");
  }
  result = cnv.tune(options);
  if (result) {
    return cb(result);
  }
  return fs.stat(srcfile, function(err, stat) {
    if (err) {
      return cb("Файл источник не найден");
    }
    return cnv["do"](cb);
  });
};
