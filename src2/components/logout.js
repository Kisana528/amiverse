import React, { useContext } from 'react'
import axios from '@/lib/axios'
import { appContext } from '@/pages/_app'
import { useRouter } from 'next/router'

export default function Logout() {
  const setLoginLoading = useContext(appContext).setLoginLoading
  const loggedIn = useContext(appContext).loggedIn
  const setLoggedIn = useContext(appContext).setLoggedIn
  const setFlash = useContext(appContext).setFlash
  const router = useRouter()

  const handleLogout = async () => {
    setLoginLoading(true)
    await axios.delete('/api/logout')
      .then(response => {
        if (!response.data.logged_in) {
          setLoggedIn(false)
          router.push('/').then(() => {
            setFlash('ログアウトしました')
            setLoginLoading(false)
          })
        } else {
          setFlash('ログアウトできませんでした')
        }
      })
      .catch(err => {
        setFlash('ログアウト通信例外')
      })
  }

  return (
    <>
      {loggedIn ? <button onClick={handleLogout}>ログアウト</button> : ''}
      <style jsx="true">{`
      `}</style>
    </>
  )
}