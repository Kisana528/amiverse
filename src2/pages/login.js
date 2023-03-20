import React, { useEffect, useState, useContext } from 'react'
import axios from '../lib/axios'
import { appContext } from './_app'
import { useRouter } from 'next/router'

export default function Login() {
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const setFlash = useContext(appContext).setFlash
  const [loginStatus, setLoginStatus] = useState('')
  const [accountID, setAccountID] = useState('')
  const [password, setPassword] = useState('')
  const router = useRouter()

  const handleSubmit = async (event) => {
    event.preventDefault()
    await axios.post('/api/login', { 'name_id': accountID, password })
      .then(res => {
        if (res.data.logged_in) {
          setLoggedIn(true)
          setLoginStatus('ログインしました')
          setFlash('ログインしたよ')
          router.push('/')
        } else if (!res.data.logged_in) {
          setLoginStatus('情報が間違っています')
        } else {
          setLoginStatus('ログインできませんでした')
        }
      })
      .catch(err => {
        setLoginStatus('ログイン通信例外')
      })
  }
  const handleLogout = async () => {
    await axios.delete('/api/logout')
      .then(res => {
        if (!res.data.logged_in) {
          setLoggedIn(false)
          setLoginStatus('ログアウトしました')
        } else {
          setLoginStatus('ログアウト処理ができませんでした')
        }
      })
      .catch(err => {
        setLoginStatus('ログアウト通信例外')
      })
  }
  return (
    <>
      <h1>Amiverse.netへログイン</h1>
      {loggedIn ? 't' : 'f'}
      {loginStatus}
      <br />
      <form onSubmit={handleSubmit}>
        <label>
          アカウントID:
          <input type="text" value={accountID} onChange={(e) => setAccountID(e.target.value)} />
        </label>
        <br />
        <label>
          パスワード:
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
        </label>
        <br />
        <button type="submit">送信</button>
      </form>
      <button onClick={handleLogout}>ログアウト</button>
    </>
  )
}