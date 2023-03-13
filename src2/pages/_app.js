import '@/styles/globals.css'
import Layout from '../components/layout'
import axios from '../lib/axios'
import React, { useState, useEffect, createContext } from 'react'

export const appContext = createContext()

export default function App({ Component, pageProps }) {
  const [isDark, setIsDark] = useState(false)
  const [loggedIn, setLoggedIn] = useState(false)
  const [loginStatus, setLoginStatus] = useState('loading')
  const modeTrigger = () => setIsDark(!isDark)
  useEffect(() => {
    if(window.matchMedia('(prefers-color-scheme: dark)').matches === true){
      modeTrigger()
    } 
  },[])
  let ignore = false
  useEffect(() => {
    if (!ignore) {
      axios.post('/api/new')
      .then(response => {
        setLoginStatus('ready')
      })
      .catch(err => {
        setLoginStatus('csrf-cookie-error')
      })
      axios.post('/api/logged-in')
      .then(response => {
        if(response.data.logged_in){
          setLoginStatus(response.data.icon_path + 'さん')
        } else {
          setLoginStatus(response.data.name)
        }
      })
      .catch(err => {
        setLoginStatus('logged-in-error')
      })
    }
    return () => {ignore = true}
  },[])
  return (
      <appContext.Provider value={{isDark, setIsDark, modeTrigger,
        loggedIn, setLoggedIn,
        loginStatus, setLoginStatus}}>
        <Layout isDark={isDark}>
          <Component {...pageProps} />
        </Layout>
      </appContext.Provider>
  )
}
