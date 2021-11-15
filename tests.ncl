let H = import "hurl.ncl" in
let google = [m#"xpath "string(/html/head/title)" contains "Google"#m] in
[
  H.getWith "https://google.com/" google
]
