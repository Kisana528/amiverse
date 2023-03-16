import '@/styles/globals.css'
import Layout from '@/components/layout'
import axios from '@/lib/axios'
import React, { useState, useEffect, createContext } from 'react'
import { useRouter } from 'next/router'

export const appContext = createContext()
export default function App({ Component, pageProps }) {
  const [loading, setLoading] = useState(true)
  const [loginStatus, setLoginStatus] = useState('セッション作成中')
  const [loggedIn, setLoggedIn] = useState(false)
  const [account, setAccount] = useState({})
  const [flash, setFlash] = useState('')
  const [dark, setDark] = useState(false)
  const modeTrigger = () => setDark(!dark)
  let ignore = false
  const router = useRouter()

  useEffect(() => {
    if(window.matchMedia('(prefers-color-scheme: dark)').matches === true){
      modeTrigger()
    }
    if (!ignore) {
      async function getCSRFToken() {
        await axios.post('/api/new')
        .then(res => {
          setLoginStatus('アカウント情報確認中')
        })
        .catch(err => {
          setLoginStatus('サーバーエラー')
        })
      }
      async function getAccountInfo() {
        await axios.post('/api/logged-in')
        .then(res => {
          if(res.data.logged_in){
            setLoginStatus('ログイン中')
            setLoggedIn(true)
            setAccount(res.data)
          } else {
            setLoginStatus('未ログイン')
            setLoggedIn(false)
          }
          setLoading(false)
        })
        .catch(err => {
          setLoginStatus('アカウントエラー')
        })
      }
      getCSRFToken()
      getAccountInfo()
    }
    return () => {ignore = true}
  },[])
  useEffect(() => {
	  if(router.pathname === "/") return
    if(loggedIn){
      router.push('/')
      return
    }
  },[router.pathname, loggedIn])
  return (
      <appContext.Provider value={{loading, setLoading,
        loginStatus, setLoginStatus,
        loggedIn, setLoggedIn,
        account, setAccount,
        flash, setFlash,
        dark, setDark, modeTrigger,
      }}>
        <Layout>
          <Component {...pageProps} />
        </Layout>
      </appContext.Provider>
  )
}
