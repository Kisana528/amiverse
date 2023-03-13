import React, { useEffect, useState, useContext } from 'react'
import axios from '../lib/axios'
import {appContext} from './_app'

export default function Login() {
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const loginStatus = useContext(appContext).loginStatus
  const setLoginStatus = useContext(appContext).setLoginStatus
  const [accountID, setAccountID] = useState('')
  const [password, setPassword] = useState('')

  const handleSubmit = async (event) => {
    event.preventDefault()
    await axios.post('/api/login', { 'name_id': accountID, password })
      .then(response => {
        setLoginStatus(response.data.message)
        if(response.data.logged_in) {
          setLoggedIn(true)
        }
      })
      .catch(err => {
        setLoginStatus('Error')
        console.log(err)
      })
  }
  const handleLogout = async () => {
    await axios.delete('/api/logout')
      .then(response => {
        setLoginStatus(response.data.message)
        if(!response.data.logged_in) {
          setLoggedIn(false)
        }
      })
      .catch(err => {
        setLoginStatus('Error')
        console.log(err)
      })
  }
  return (
    <>
      <main>
        <h1>Amiverse.netへログイン</h1>
        {loggedIn ? 'ログイン中' : '未ログイン'}
        <br />
        { loginStatus }
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
      </main>
    </>
  )
}