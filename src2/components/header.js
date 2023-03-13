import Link from 'next/link'
import React, { useEffect, useState, useContext } from 'react'
import {appContext} from '../pages/_app'

export default function Header() {
  const loginStatus = useContext(appContext).loginStatus
  return (
    <header>
      <div className="top">
        <Link href="/">
          <div className="top-inner">
            Amiverse
          </div>
        </Link>
      </div>
      <div>{loginStatus}</div>
      <style jsx="true">{`
      header {
        display: flex;
        position: sticky;
        top: 0;
        width: 100%;
        height: 60px;
        background-color: rgb(186, 255, 232);
        align-items: center;
        justify-content: center;
      }
      .top {

      }
      .top-inner {
        line-height: 60px;
        padding: 0 10px;
      }
      `}</style>
    </header>
  )
}