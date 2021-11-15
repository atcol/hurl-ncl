let defaultDuration = "duration < 1000" in

let URL = fun label val =>
  if strings.isMatch val "^(http|https)://.*"
  then
    val
  else
    contracts.blame label 
  in

let HTTPStatus = fun l v =>
  if v >= 100 && v <= 599
  then
    v
  else 
    contracts.blame l
  in

let Request | doc "HTTP Request" = {
  method | Str //<GET, DELETE, HEAD, PATCH, POST, PUT, OPTIONS>
         | default = "GET",
  url | #URL,
  body | Str
       | default = "",

} in

let Entry  | doc "A Hurl entry" = {
  request  | #Request,
  status   | #HTTPStatus
           | default = 200,
  asserts  | List Str
           | default = [
             defaultDuration,
           ],
  captures | List #Capture
           | default = [],
} in

{
  get = fun u => {
    request = {
      url = u
    },
  } | #Entry,
  getWith = fun u a => {
    asserts = [
      defaultDuration,
      "header \"Content-Type\" == \"application/json\"",
    ] @ a,
    request = {
      url = u
    },
  } | #Entry,
  getJSON = fun u => {
    asserts = [
      defaultDuration,
      "header \"Content-Type\" == \"application/json\"",
    ],
    request = {
      url = u
    },
  } | #Entry,
  post = fun u b => {
    request = {
      body = b,
      method = "POST",
      url = u,
    },
  } | #Entry,
}
