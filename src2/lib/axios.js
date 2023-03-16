// axiosに設定を追加する

import axios from 'axios'

axios.defaults.baseURL = process.env.NEXT_PUBLIC_HTTPNAME
axios.defaults.xsrfCookieName = 'CSRF-TOKEN'
axios.defaults.xsrfHeaderName = 'X-CSRF-Token'
axios.defaults.withCredentials = true
axios.defaults.headers.common['Content-Type'] = 'application/json'
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
axios.defaults.timeout = 2500
axios.defaults.responseType = 'json'

export default axios