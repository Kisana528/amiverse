import React, { useEffect, useState, useContext } from 'react'
import axios from '../lib/axios'
import {appContext} from './_app'
import { useRouter } from 'next/router'

export default function Signup() {
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const loginStatus = useContext(appContext).loginStatus
  const setLoginStatus = useContext(appContext).setLoginStatus
  const [invitationCode, setInvitationCode] = useState('')
  const [invited, setInvited] = useState(false)
  const [accountID, setAccountID] = useState('')
  const [password, setPassword] = useState('')
  const [passwordConfirm, setPasswordConfirm] = useState('')

  const checkInvitationCode = async (event) => {
    event.preventDefault()
    setInvited(true)
  }
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
  const invitationCodeForm = (
    <form onSubmit={checkInvitationCode}>
      <label>
        招待コード:
        <input type="text" value={invitationCode} onChange={(e) => setInvitationCode(e.target.value)} ></input>
      </label>
      <button type="submit">送信</button>
    </form>
  )
  const AccountForm = (
    <form onSubmit={handleSubmit}>
      <label>
        招待コード:
        <input type="text" value={invitationCode} onChange={(e) => setInvitationCode(e.target.value)} />
      </label>
      <br />
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
  )
  let form
  if(invited) {
    form = AccountForm
  } else {
    form = invitationCodeForm
  }
  return (
    <>
      <main>
        <h1>サインイン</h1>
        { form }
      </main>
    </>
  )
}