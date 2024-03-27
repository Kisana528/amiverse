import React, { useEffect, useState, useContext } from 'react'
import axios from '@/lib/axios'
import {appContext} from '@/pages/_app'
import ItemAccount from '@/components/item_account'
import Post from '@/components/post'

export default function Settings() {
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
      <h1>設定</h1>
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
