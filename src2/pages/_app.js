import '@/styles/globals.css'
import Layout from '@/components/layout'
import Head from '@/components/head'
import axios from '@/lib/axios'
import React, { useState, useEffect, createContext } from 'react'
import { useRouter } from 'next/router'

const loggedOutPaths = ['/login','/signup']//ログイン中はアクセスできない
const loggedInPaths = ['/items']//ログイン中でないとアクセスできない

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
  let ignore = false
  const router = useRouter()

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
          //setLoading(false)
        }
      }
      fetchAccountInfo()
    }
    return () => {ignore = true}
  },[])
  useEffect(() => {
    if(!loading && !loginLoading){
      if(loggedInPaths.includes(router.pathname)){
        if(loggedIn){
          return
        } else {
          setFlash(`${router.pathname}へアクセスするにはログインしてください`)
          router.push('/')
          return
        }
      }
      if(loggedIn && loggedInPaths.includes(router.pathname)) return
      if(!loggedOutPaths.includes(router.pathname)) return
      if(loggedIn){
        setFlash(`ログイン済みですので${router.pathname}へアクセスできません`)
        router.push('/')
        return
      }
    }
  },[router.pathname, loggedIn])
  return (
      <appContext.Provider value={{loading, setLoading,
        loginLoading, setLoginLoading,
        loadingStatus, setLoadingStatus,
        loginForm, setLoginForm, loginFormTrigger,
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
