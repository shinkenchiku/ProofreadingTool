module.exports = [
  {
    message: `"することが可能$1"は冗長な表現です。"することが可能"を省き簡潔な表現にすると文章が明瞭になります。
参考: http://qiita.com/takahi-i/items/a93dc2ff42af6b93f6e0`,
    tokens: [
      {
        surface_form: "する",
        pos: "動詞",
        pos_detail_1: "自立",
        pos_detail_2: "*",
        pos_detail_3: "*",
        conjugated_type: "サ変・スル",
        conjugated_form: "基本形",
        basic_form: "する",
        reading: "スル",
        pronunciation: "スル",
      },
      {
        surface_form: "こと",
        pos: "名詞",
        pos_detail_1: "非自立",
        pos_detail_2: "一般",
        pos_detail_3: "*",
        conjugated_type: "*",
        conjugated_form: "*",
        basic_form: "こと",
        reading: "コト",
        pronunciation: "コト",
      },
      {
        surface_form: "が",
        pos: "助詞",
        pos_detail_1: "格助詞",
        pos_detail_2: "一般",
        pos_detail_3: "*",
        conjugated_type: "*",
        conjugated_form: "*",
        basic_form: "が",
        reading: "ガ",
        pronunciation: "ガ",
      },
      {
        surface_form: "可能",
        pos: "名詞",
        pos_detail_1: "形容動詞語幹",
        pos_detail_2: "*",
        pos_detail_3: "*",
        conjugated_type: "*",
        conjugated_form: "*",
        basic_form: "可能",
        reading: "カノウ",
        pronunciation: "カノー",
      },
      {
        pos: "助動詞",
        _capture: "$1",
      },
    ],
  },
  {
    message: '"適用"の誤用である可能性があります。適応 => 適用',
    expected: "を適用",
    tokens: [
      {
        surface_form: "を",
        pos: "助詞",
        pos_detail_1: "格助詞",
        pos_detail_2: "一般",
        pos_detail_3: "*",
        conjugated_type: "*",
        conjugated_form: "*",
        basic_form: "を",
        reading: "ヲ",
        pronunciation: "ヲ",
      },
      {
        surface_form: "適応",
        pos: "名詞",
        pos_detail_1: "サ変接続",
        pos_detail_2: "*",
        pos_detail_3: "*",
        conjugated_type: "*",
        conjugated_form: "*",
        basic_form: "適応",
        reading: "テキオウ",
        pronunciation: "テキオー",
      },
    ],
  },
];
