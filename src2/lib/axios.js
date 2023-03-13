import axios from 'axios'

axios.defaults.baseURL = 'http://localhost:3000'
axios.defaults.xsrfCookieName = 'CSRF-TOKEN'
axios.defaults.xsrfHeaderName = 'X-CSRF-Token'
axios.defaults.withCredentials = true
axios.defaults.headers.common['Content-Type'] = 'application/json'
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
axios.defaults.timeout = 2500
axios.defaults.responseType = 'json'

export default axios