import React, { useEffect, useState, useContext } from 'react'
import axios from '@/lib/axios'
import {appContext} from '@/pages/_app'
import ItemAccount from '@/components/item_account'
import Post from '@/components/post'

export default function Dashboard() {
  const loggedIn = useContext(appContext).loggedIn
  const loggedInPage = useContext(appContext).loggedInPage
  let ignore = false
  useEffect(() => {
    loggedInPage()
    if (!ignore && loggedIn) {
      // fetch
    }
    return () => {ignore = true}
  },[loggedIn])

  return (
    <>
      <h1>Amiverse</h1>
      <div className="div_1">
        <h2>お財布</h2>
      </div>
      <div className="div_1">
        <h2>現在地</h2>
      </div>
      <div className="div_1">
        <h2>とおりすがり交信</h2>
      </div>
      <div className="div_1">
        <h2>ワールド</h2>
      </div>
      <div className="div_1">
        <h2>aShop</h2>
      </div>
      <div className="div_1">
        <h2>なめらか紙芝居</h2>
      </div>
      <div className="div_1">
        <h2>アプリ</h2>
      </div>
      <div className="div_1">
        <h2>グループ</h2>
      </div>
      <style jsx>{`
        .div_1 {
        }
      `}</style>
    </>
  )
}
