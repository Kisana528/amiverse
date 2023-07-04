import React, { useEffect, useState, useContext } from 'react'
import axios from '@/lib/axios'
import { appContext } from '@/pages/_app'
import { useRouter } from 'next/router'

export default function Login() {
  const setLoginLoading = useContext(appContext).setLoginLoading
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const setLoginForm = useContext(appContext).setLoginForm
  const setFlash = useContext(appContext).setFlash
  const [loginStatus, setLoginStatus] = useState('')
  const [accountID, setAccountID] = useState('')
  const [password, setPassword] = useState('')
  const router = useRouter()
  
  const handleCancel = () => setLoginForm(false)

  const handleSubmit = async (event) => {
    event.preventDefault()
    setLoginLoading(true)
    await axios.post('/login', { 'name_id': accountID, password })
      .then(res => {
        if (res.data.logged_in) {
          setLoggedIn(true)
          router.push('/').then(() => {
            setLoginStatus('ログインしました')
            setFlash('ログインしたよ')
            setLoginLoading(false)
            setLoginForm(false)
          })
        } else if (!res.data.logged_in) {
          setLoginStatus('情報が間違っています')
        } else {
          setLoginStatus('ログインできませんでした')
        }
      })
      .catch(err => {
        if (err.response.status == 401) {
          if (!err.response.data.logged_in) {
            setLoginStatus('情報が間違っています')
          } else {
            setLoginStatus('ログインできませんでした')
          }
        } else {
          setLoginStatus('ログイン通信例外')
          setLoginLoading(false)
        }
      })

  }
  return (
    <>
      <div className="login-fullscreen" onClick={handleCancel}>
      </div>
        <div className="login-container">
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
        </div>
      <style jsx>{`
        .login-fullscreen {
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100svh;
          backdrop-filter: blur(3px);
          z-index: 20;
        }
        .login-container {
          position: fixed;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          backdrop-filter: blur(3px);
          background: var(--blur-color);
          z-index: 10;
          border: 2px solid var(--border-color);
          border-radius: 12px;
          z-index: 21;
        }
      `}</style>
    </>
  )
}