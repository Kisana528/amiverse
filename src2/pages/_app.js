import '@/styles/globals.css'
import Layout from '@/components/layout'
import Head from '@/components/head'
import axios from '@/lib/axios'
import React, { useState, useEffect, createContext } from 'react'
import { useRouter } from 'next/router'

export const appContext = createContext()
export default function App({ Component, pageProps }) {
  const [loading, setLoading] = useState(true)
  const [loadingStatus, setLoadingStatus] = useState('セッション作成中')
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
          setLoadingStatus('アカウント情報確認中')
        })
        .catch(err => {
          setLoadingStatus('サーバーエラー')
        })
      }
      async function getAccountInfo() {
        await axios.post('/api/logged-in')
        .then(res => {
          if(res.data.logged_in){
            setLoadingStatus('ログイン中')
            setLoggedIn(true)
            setAccount(res.data)
          } else {
            setLoadingStatus('未ログイン')
            setLoggedIn(false)
          }
        })
        .catch(err => {
          setLoadingStatus('アカウントエラー')
        })
      }
      getCSRFToken()
      .then(() => {
        getAccountInfo()
        .then(() => {
          setLoading(false)
        })
      })
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
        loadingStatus, setLoadingStatus,
        loggedIn, setLoggedIn,
        account, setAccount,
        flash, setFlash,
        dark, setDark, modeTrigger,
      }}>
        <Head />
        <Layout>
          <Component {...pageProps} />
        </Layout>
      </appContext.Provider>
  )
}
