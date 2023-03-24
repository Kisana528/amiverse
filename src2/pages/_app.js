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
          await axios.post('/api/new')
          setLoadingStatus('アカウント情報確認中')
          const response = await axios.post('/api/logged-in')
          const data = response.data
          setLoadingStatus(data.logged_in ? 'ログイン中' : '未ログイン')
          setLoading(false)
          setLoginLoading(false)
          setLoggedIn(data.logged_in)
          setAccount(data)
        } catch (error) {
          setLoadingStatus(error.response ? 'アカウントエラー' : 'サーバーエラー')
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
          setFlash('ログインしてください')
          router.push('/')
          return
        }
      }
      if(loggedIn && loggedInPaths.includes(router.pathname)) return
      if(!loggedOutPaths.includes(router.pathname)) return
      if(loggedIn){
        setFlash('ログイン済みです')
        router.push('/')
        return
      }
    }
  },[router.pathname, loggedIn])
  return (
      <appContext.Provider value={{loading, setLoading,
        loginLoading, setLoginLoading,
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
