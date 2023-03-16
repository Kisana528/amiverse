import Link from 'next/link'
import React, {useContext} from 'react'
import axios from '../lib/axios'
import {appContext} from '../pages/_app'

export default function Tab() {
  const isDark = useContext(appContext).isDark
  const setLoginStatus = useContext(appContext).setLoginStatus
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const modeTrigger = useContext(appContext).modeTrigger
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
    <div className="tab">
      <p>content here</p>
      <button onClick={modeTrigger}>{isDark ? '🌙' : '☀'}</button>
      {loggedIn ? <button onClick={handleLogout}>ログアウト</button> : '' }
      <style jsx="true">{`
        .tab {
          display: none;
        }
         @media (min-width: 600px) {
          .tab {
            display: inline-block;
          }
        }
      `}</style>
    </div>
  )
}