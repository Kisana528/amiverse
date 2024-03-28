import '@/styles/globals.css'
import Layout from '@/components/layout'
import Head from '@/components/head'
import axios from '@/lib/axios'
import React, { useState, useEffect, createContext } from 'react'
import { useRouter } from 'next/router'

export const appContext = createContext()
export default function App({ Component, pageProps }) {
  const [loading, setLoading] = useState(true)
  const [loadingMessage, setLoadingMessage] = useState('セッション作成中')
  const [loggedIn, setLoggedIn] = useState(false)
  const [account, setAccount] = useState({})
  const [flashKind, setFlashKind] = useState('')
  const [flashMessage, setFlashMessage] = useState('')
  const [modal, setModal] = useState(false)
  const modalTrigger = () => setModal(!modal)
  const [darkThreme, setDarkThreme] = useState(false)
  const darkThremeTrigger = () => setDarkThreme(!darkThreme)
  const router = useRouter()
  const loggedInPage = () => {
    if(!loggedIn){
      setFlashKind('info')
      setFlashMessage(`${router.pathname}へアクセスするにはログインしてください`)
      console.log(flash)
      router.push('/')
      return
    }
  }
  const loggedOutPage = () => {
    if(loggedIn){
      setFlashKind('info')
      setFlashMessage(`ログイン済みですので${router.pathname}へアクセスできません`)
      router.push('/')
      return
    }
  }

  useEffect(() => {
    setDarkThreme(window.matchMedia('(prefers-color-scheme: dark)').matches)
    async function startUp() {
      try {
        await axios.post('/sessions/new')
        setLoadingMessage('アカウント情報確認中')
        const res = await axios.post('/sessions/check')
        setLoggedIn(res.data.logged_in)
        setAccount(res.data.account)
      } catch (err) {
        setFlashKind('danger')
        setFlashMessage(err.response ? 'アカウントエラー' : 'サーバーエラー')
      }
      setLoadingMessage('ロード完了')
      setLoading(false)
    }
    startUp()
  },[])

  return (
      <appContext.Provider value={{
        loading, setLoading,
        loadingMessage, setLoadingMessage,
        loggedIn, setLoggedIn,
        account, setAccount,
        flashKind, setFlashKind,
        flashMessage, setFlashMessage,
        modal, setModal, modalTrigger,
        darkThreme, setDarkThreme, darkThremeTrigger,
        loggedInPage, loggedOutPage
      }}>
        <Head />
        <Layout>
          <Component {...pageProps} />
        </Layout>
      </appContext.Provider>
  )
}
