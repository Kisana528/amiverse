import '@/styles/globals.css'
import Layout from '@/components/layout'
import Head from '@/components/head'
import axios from '@/lib/axios'
import React, { useState, useEffect, createContext } from 'react'
import { useRouter } from 'next/router'

export const appContext = createContext()
export default function App({ Component, pageProps }) {
  const [loading, setLoading] = useState(true)
  const [loginLoading, setLoginLoading] = useState(true)
  const [loadingStatus, setLoadingStatus] = useState('セッション作成中')
  const [loggedIn, setLoggedIn] = useState(false)
  const [account, setAccount] = useState({})
  const [flash, setFlash] = useState('')
  const [loginForm, setLoginForm] = useState(false)
  const loginFormTrigger = () => setLoginForm(!loginForm)
  const [dark, setDark] = useState(false)
  const modeTrigger = () => setDark(!dark)
  const router = useRouter()
  const loggedInPage = () => {
    if(!loggedIn){
      setFlash(`${router.pathname}へアクセスするにはログインしてください`)
      router.push('/')
      return
    }
  }
  const loggedOutPage = () => {
    if(loggedIn){
      setFlash(`ログイン済みですので${router.pathname}へアクセスできません`)
      router.push('/')
      return
    }
  }
  let ignore = false

  useEffect(() => {
    if(window.matchMedia('(prefers-color-scheme: dark)').matches === true){
      modeTrigger()
    }
    if (!ignore) {
      async function fetchAccountInfo() {
        try {
          await axios.post('/sessions/new')
          setLoadingStatus('アカウント情報確認中')
          const response = await axios.post('/logged_in')
          const data = response.data
          setLoadingStatus(data.logged_in ? 'ログイン中' : '未ログイン')
          setLoading(false)
          setLoginLoading(false)
          setLoggedIn(data.logged_in)
          setAccount(data)
        } catch (error) {
          setLoadingStatus(error.response ? 'ログインエラー' : 'サーバーエラー')
          setLoading(false)
          setFlash(`サーバーエラー`)
        }
      }
      fetchAccountInfo()
    }
    return () => {ignore = true}
  },[])

  return (
      <appContext.Provider value={{
        loading, setLoading,
        loginLoading, setLoginLoading,
        loadingStatus, setLoadingStatus,
        loginForm, setLoginForm, loginFormTrigger,
        loggedIn, setLoggedIn,
        account, setAccount,
        flash, setFlash,
        dark, setDark, modeTrigger,
        loggedInPage, loggedOutPage
      }}>
        <Head />
        <Layout>
          <Component {...pageProps} />
        </Layout>
      </appContext.Provider>
  )
}
