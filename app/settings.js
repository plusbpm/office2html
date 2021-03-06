// Generated by CoffeeScript 1.8.0
var all_ext, k, path, support_ext, v,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

path = require("path");

support_ext = {
  pdf: ["pdf"],
  docx: ["docx"],
  unoconv: ["doc", "odt", "xls", "xlsx", "ods", "ppt", "pptx"]
};

all_ext = [];

for (k in support_ext) {
  v = support_ext[k];
  all_ext = all_ext.concat(v);
}

module.exports = {
  pdf: {
    "default": ['--zoom', '1.33'],
    ipad: ['--fit-width', '968']
  },
  docx: {},
  unoconv: {},
  tmp_dir: "/tmp",
  saveNamedOptions: function(type, name, opts) {
    if (!type || (module.exports[type] == null)) {
      return "Указаный тип источника не предусмотрен (pdf,docx,unoconv)";
    }
    if (!name) {
      return "Не указано имя";
    }
    if (opts) {
      if (!Array.isArray(opts)) {
        return "Опции должны быть массивом строк";
      }
      return module.exports[type][name] = opts;
    } else {
      return delete module.exports[type][name];
    }
  },
  setTempDir: function(dir) {
    return module.exports.tmp_dir = path.normalize(dir);
  },
  support: function(ext) {
    return __indexOf.call(all_ext, ext) >= 0;
  }
};
