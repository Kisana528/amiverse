import React, { useEffect, useState, useContext } from 'react'
import axios from '@/lib/axios'
import { appContext } from './_app'
import { useRouter } from 'next/router'

export default function Signup() {
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const loginStatus = useContext(appContext).loginStatus
  const setLoginStatus = useContext(appContext).setLoginStatus
  const setFlash = useContext(appContext).setFlash
  const router = useRouter()
  const [signupStatus, setSignupStatus] = useState('未確認')
  const [invited, setInvited] = useState(false)
  const [invitationCode, setInvitationCode] = useState('')
  const [name, setName] = useState('')
  const [nameID, setNameID] = useState('')
  const [password, setPassword] = useState('')
  const [passwordConfirmation, setPasswordConfirmation] = useState('')

  const checkInvitationCode = async (event) => {
    event.preventDefault()
    await axios.post('/api/check-invitation-code', { 'invitation_code': invitationCode })
      .then(res => {
        if (res.data.invitation_code) {
          setSignupStatus('招待を確認済み')
          setInvited(true)
        } else {
          setSignupStatus('招待が確認できませんでした')
        }
      })
      .catch(err => {
        setSignupStatus('招待確認通信例外')
      })
  }
  const handleSubmit = async (event) => {
    event.preventDefault()
    await axios.post('/api/signup', {
      'invitation_code': invitationCode,
      'name': name,
      'name_id': nameID,
      'password': password,
      'password_confirmation': passwordConfirmation
    })
      .then(res => {
        if (res.data.created) {
          setSignupStatus('作成されました')
          setFlash('作成したよ')
          router.push('/')
        } else if (!res.data.created) {
          setSignupStatus('間違っています')
        } else if (!res.data.invitation_code) {
          setSignupStatus('招待が確認できませんでした')
        } else {
          setSignupStatus('アカウントが作成できませんでした')
        }
      })
      .catch(err => {
        setSignupStatus('アカウント作成通信例外')
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
        なまえ:
        <input type="text" value={name} onChange={(e) => setName(e.target.value)} />
      </label>
      <br />
      <label>
        ID:
        <input type="text" value={nameID} onChange={(e) => setNameID(e.target.value)} />
      </label>
      <br />
      <label>
        パスワード:
        <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      </label>
      <br />
      <label>
        パスワード確認:
        <input type="password" value={passwordConfirmation} onChange={(e) => setPasswordConfirmation(e.target.value)} />
      </label>
      <br />
      <button type="submit">送信</button>
    </form>
  )
  let form
  if (invited) {
    form = AccountForm
  } else {
    form = invitationCodeForm
  }
  return (
    <>
      <main>
        <h1>サインイン</h1>
        <span>{signupStatus}</span>
        {form}
      </main>
    </>
  )
}