import Header from './header'
import Footer from './footer'
import Nav from './nav'
import Tab from './tab'
import Login from './login'
import { appContext } from '@/pages/_app'
import React, { useContext, useState } from 'react'

export default function Layout({ children }) {
  const loading = useContext(appContext).loading
  const setLoading = useContext(appContext).setLoading
  const loadingStatus = useContext(appContext).loadingStatus
  const dark = useContext(appContext).dark
  const flash = useContext(appContext).flash
  const setFlash = useContext(appContext).setFlash
  const loginForm = useContext(appContext).loginForm
  const [removeFlash, setRemoveFlash] = useState(false)
  const handleClick = () => {
    if(removeFlash){
      setFlash('')
      setRemoveFlash(false)
    } else {
      setFlash(flash + '(もう一度押して削除)')
      setRemoveFlash(true)
    }
  }
  const closeLoading = () => setLoading(false)
  
  return (
    <div className={`all ${dark ? "dark-mode" : "light-mode"} ${loading ? "loading-top" : ""}`}>
      <div className={`${loading ? "loading" : "loading-hide"}`}>
        <div className='loading-info'>
          <div className="loading-logo">
            <svg width="100" height="100" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="50" cy="50" r="29" fill="#8BFFB2"/>
              <path d="M22 58C8.00001 76.5 99.5 53 78.5 45M21 55.5C-30 96.5 138.5 51 77.5 42" stroke="white"/>
            </svg>
            <br />
            Amiverse
          </div>
          <div className="loading-status">{loadingStatus}</div>
        </div>
        <div className='loading-detail'>
          <div className='close-loading' onClick={closeLoading} >閉じる</div>
        </div>
      </div>
      <div className="main-container">
        <Nav />
        {loginForm ? <Login /> : ''}
        <main>
          {children}
          {flash ? <div className="flash" onClick={handleClick}>{flash}</div> : ''}
        </main>
        <Tab />
      </div>
      <style jsx>{`
        .all {
          background: var(--background-color);
          color: var(--font-color);
        }
        .loading-top {
          width: 100vw;
          height: 100svh;
          overflow: hidden;
        }
        .loading-hide {
          display: none;
        }
        .loading {
          z-index: 10;
          display: inline-block;
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100svh;
          background: rgb(22,22,22);
        }
        .loading-info {
          display: flex;
          align-items: center;
          justify-content: center;
          flex-direction: column;
          height: calc(100svh - 100px);
        }
        .loading-logo {
          font-size: 32px;
          font-family: math;
          color: #b057e8;
        }
        .loading-status {
          color: #64a5fc;
        }
        .close-loading {
          display: inline;
        }
        main {
          flex-grow: 1;
          box-sizing: border-box;
          width: 100%;
          min-height: 100svh;
        }
        @media (min-width: 400px) {
          main {
            border-left: 0.5px solid var(--border-color);
            width: calc(100% - 30px);
          }
        }
        @media (min-width: 600px) {
          main {
            border-right: 0.5px solid var(--border-color);
            width: calc(100% - 100px - 100px);
          }
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