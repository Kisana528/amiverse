import Header from './header'
import Footer from './footer'
import Nav from './nav'
import Tab from './tab'
import {appContext} from '../pages/_app'
import React, { useState, useEffect, useContext } from 'react'

export default function Layout({ children }) {
  const loading = useContext(appContext).loading
  const loginStatus = useContext(appContext).loginStatus
  const dark = useContext(appContext).dark
  const flash = useContext(appContext).flash
  return (
    <div className={`all ${dark ? "dark" : ""} ${loading ? "loading-top" : ""}` }>
      <div className={`loading-hide ${loading ? "loading" : ""}`}>
        <div className="loading-logo">Amiverse</div>
        <div className="loading-status">{loginStatus}</div>
      </div>
      <Header />
      <div className="main-container">
        <Nav />
        <main>
          {children}
          {flash ? <div className="flash">{flash}</div> : ''}
        </main>
        <Tab />
      </div>
      <style jsx="true">{`
        .all {
        }
        .dark {
          background-color: #000000e6;
          color: #fff;
        }
        .loading-top {
          width: 100vw;
          height: 100vh;
          overflow: hidden;
        }
        .loading-hide {
          display: none;
        }
        .loading {
          z-index: 10;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          background: #76ffdf;
        }
        .loading-logo {
          font-size: 50px;
          font-family: math;
          color: #74006e;
        }
        .loading-status {
          color: #1a4682;
        }
        main {
          height: 300vh;
          //background-color: rgb(209, 233, 255);
          flex-grow: 1;
        }
        .main-container {
          display: flex;
        }
        .flash {
          border: 1px solid #000;
          border-radius: 5px;
          padding: 3px;
          position: fixed;
          right: 10px;
          background-color: #4fff67bb;
          bottom: 70px;
          z-index: 200;
        }
      `}</style>
    </div>
  )
}