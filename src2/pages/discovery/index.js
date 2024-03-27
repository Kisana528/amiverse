import React, { useEffect, useState, useContext } from 'react'
import axios from '@/lib/axios'
import {appContext} from '@/pages/_app'
import ItemAccount from '@/components/item_account'
import Post from '@/components/post'

export default function Discovery() {
  const loggedIn = useContext(appContext).loggedIn
  let ignore = false
  useEffect(() => {
    if (!ignore && loggedIn) {
      // fetch
    }
    return () => {ignore = true}
  },[loggedIn])

  return (
    <>
      <h1>みつける</h1>
      <div className="div_1">
        <h2>検索</h2>
      </div>
      <div className="div_1">
        <h2>トレンド</h2>
      </div>
      <div className="div_1">
        <h2>おすすめ</h2>
      </div>
      <div className="div_1">
        <h2>ニュース</h2>
      </div>
      <style jsx>{`
        .div_1 {
        }
      `}</style>
    </>
  )
}
