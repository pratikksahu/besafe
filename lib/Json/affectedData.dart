class AffectedData {
  String date;
  String status;
  String an;
  String ap;
  String ar;
  String as;
  String br;
  String cg;
  String ch;
  String dh;
  String dd;
  String dl;
  String ga;
  String gj;
  String hr;
  String hp;
  String jk;
  String jh;
  String ka;
  String kl;
  String la;
  String ld;
  String mp;
  String mh;
  String mn;
  String ml;
  String mz;
  String nl;
  String or;
  String py;
  String pb;
  String rj;
  String sk;
  String tn;
  String ts;
  String tr;
  String up;
  String uk;
  String wb;
  AffectedData({
    this.date,
    this.status,
    this.an,
    this.ap,
    this.ar,
    this.as,
    this.br,
    this.cg,
    this.ch,
    this.dh,
    this.dd,
    this.dl,
    this.ga,
    this.gj,
    this.hr,
    this.hp,
    this.jk,
    this.jh,
    this.ka,
    this.kl,
    this.la,
    this.ld,
    this.mp,
    this.mh,
    this.mn,
    this.ml,
    this.mz,
    this.nl,
    this.or,
    this.py,
    this.pb,
    this.rj,
    this.sk,
    this.tn,
    this.ts,
    this.tr,
    this.up,
    this.uk,
    this.wb,
  }) {
    stateCode['date'] = date;
    stateCode['status'] = status;
    stateCode['an'] = an;
    stateCode['ap'] = ap;
    stateCode['ar'] = ar;
    stateCode['as'] = as;
    stateCode['br'] = br;
    stateCode['cg'] = cg;
    stateCode['ch'] = ch;
    stateCode['dh'] = dh;
    stateCode['dd'] = dd;
    stateCode['dl'] = dl;
    stateCode['ga'] = ga;
    stateCode['gj'] = gj;
    stateCode['hr'] = hr;
    stateCode['hp'] = hp;
    stateCode['jk'] = jk;
    stateCode['jh'] = jh;
    stateCode['ka'] = ka;
    stateCode['kl'] = kl;
    stateCode['la'] = la;
    stateCode['ld'] = ld;
    stateCode['mp'] = mp;
    stateCode['mh'] = mh;
    stateCode['mn'] = mn;
    stateCode['ml'] = ml;
    stateCode['mz'] = mz;
    stateCode['nl'] = nl;
    stateCode['or'] = or;
    stateCode['py'] = py;
    stateCode['pb'] = pb;
    stateCode['rj'] = rj;
    stateCode['sk'] = sk;
    stateCode['tn'] = tn;
    stateCode['ts'] = ts;
    stateCode['tr'] = tr;
    stateCode['up'] = up;
    stateCode['uk'] = uk;
    stateCode['wb'] = wb;
  }

  factory AffectedData.fromJson(Map<String, dynamic> parsedJson) {
    return AffectedData(
      date: parsedJson['date'],
      status: parsedJson['status'],
      an: parsedJson['an'],
      ap: parsedJson['ap'],
      ar: parsedJson['ar'],
      as: parsedJson['as'],
      br: parsedJson['br'],
      cg: parsedJson['ch'],
      ch: parsedJson['ct'],
      dh: parsedJson['dh'],
      dd: parsedJson['dd'],
      dl: parsedJson['dl'],
      ga: parsedJson['ga'],
      gj: parsedJson['gj'],
      hr: parsedJson['hr'],
      hp: parsedJson['hp'],
      jk: parsedJson['jk'],
      jh: parsedJson['jh'],
      ka: parsedJson['ka'],
      kl: parsedJson['kl'],
      la: parsedJson['la'],
      ld: parsedJson['ld'],
      mp: parsedJson['mp'],
      mh: parsedJson['mh'],
      mn: parsedJson['mn'],
      ml: parsedJson['ml'],
      mz: parsedJson['mz'],
      nl: parsedJson['nl'],
      or: parsedJson['or'],
      py: parsedJson['py'],
      pb: parsedJson['pb'],
      rj: parsedJson['rj'],
      sk: parsedJson['sk'],
      tn: parsedJson['tn'],
      ts: parsedJson['tg'],
      tr: parsedJson['tr'],
      up: parsedJson['up'],
      uk: parsedJson['ut'],
      wb: parsedJson['wb'],
    );
  }

  Map<String, String> stateCode = {
    'date': '',
    'status': ' ',
    'an': ' ',
    'ap': ' ',
    'ar': ' ',
    'as': ' ',
    'br': ' ',
    'ct': ' ',
    'ch': ' ',
    'dh': ' ',
    'dd': ' ',
    'dl': ' ',
    'ga': ' ',
    'gj': ' ',
    'hr': ' ',
    'hp': ' ',
    'jk': ' ',
    'jh': ' ',
    'ka': ' ',
    'kl': ' ',
    'la': ' ',
    'ld': ' ',
    'mp': ' ',
    'mh': ' ',
    'mn': ' ',
    'ml': ' ',
    'mz': ' ',
    'nl': ' ',
    'or': ' ',
    'py': ' ',
    'pb': ' ',
    'rj': ' ',
    'sk': ' ',
    'tn': ' ',
    'ts': ' ',
    'tr': ' ',
    'up': ' ',
    'uk': ' ',
    'wb': ' ',
  };
}
