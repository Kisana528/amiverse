import { useContext } from 'react'
import { appContext } from '@/pages/_app'
import Link from 'next/link'

export default function Nav() {
  const loggedIn = useContext(appContext).loggedIn
  const account = useContext(appContext).account
  return (
    <nav>
      <div className="nav-logo">
        <div className="nav-li">
          <Link href="/">
            <div className="nav-list-container">
              <div className="nav-list-icon">🍭</div>
              <div className="nav-list-info">Amiverse</div>
            </div>
          </Link>
        </div>
      </div>
      <div className="nav-ul">
        <div className="nav-li">
          <Link href="/">
            <div className="nav-list-container">
              <div className="nav-list-icon">🪐</div>
              <div className="nav-list-info">Home</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/discovery">
            <div className="nav-list-container">
              <div className="nav-list-icon">🦄</div>
              <div className="nav-list-info">Discovery</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/dashboard">
            <div className="nav-list-container">
              <div className="nav-list-icon">😀</div>
              <div className="nav-list-info">Dashboard</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/notifications">
            <div className="nav-list-container">
              <div className="nav-list-icon">🎉</div>
              <div className="nav-list-info">Notifications</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/messages">
            <div className="nav-list-container">
              <div className="nav-list-icon">📧</div>
              <div className="nav-list-info">Messages</div>
            </div>
          </Link>
        </div>
      </div>
      <div className="nav-menu">
        <div className="nav-li">
          <Link href={loggedIn ? '/@' + account.name_id : '/'}>
            <div className="nav-list-container">
              <div className="nav-list-icon">💖</div>
              <div className="nav-list-info">Me</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/settings">
            <div className="nav-list-container">
              <div className="nav-list-icon">⚙️</div>
              <div className="nav-list-info">Settings</div>
            </div>
          </Link>
        </div>
      </div>
      <style jsx>{`
        /* FORM-2 */
        nav {
          width: 30px;
          height: 100vh;
          position: sticky;
          padding: 30px 5px;
          box-sizing: border-box;
          top: 0px;
          left: 0px;
          display: flex;
          flex-direction: column;
        }
        .nav-logo {
          margin-bottom: 30px;
        }
        .nav-ul {
          width: 100%;
          margin: 0px;
          padding: 0px;
          display: flex;
          flex-direction: column;
          flex-grow: 1;
          height: 100%;
          list-style: none;
        }
        .nav-li {
          height: 30px;
          display: flex;
          align-items: center;
        }
        .nav-list-container {
          display: flex;
          flex-direction: column;
          align-items: center;
        }
        .nav-list-icon {

        }
        .nav-list-info {
          display: none;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        @media (max-width: 700px) {
          /* FORM-1 */
          nav {
            position: fixed;
            top: auto;
            bottom: 0px;
            width: 100%;
            height: 30px;
            padding: 0px;
            backdrop-filter: blur(3px);
            background: var(--blur-color);
          }
          .nav-logo {
            display: none;
          }
          .nav-ul {
            flex-direction: row;
            justify-content: space-around;
          }
          .nav-menu {
            display: none;
          }
        }
        @media (min-width: 1300px) {
          /* FORM-3 */
          nav {
            width: 110px;
          }
          .nav-list-container {
            display: flex;
            flex-direction: row;
          }
          .nav-list-info {
            display: inline-block;
          }
        }
      `}</style>
    </nav>
  )
}