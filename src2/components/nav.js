import Link from 'next/link'

export default function Nav() {
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
              <div className="nav-list-icon">😀</div>
              <div className="nav-list-info">HOME</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/@kisana">
            <div className="nav-list-container">
              <div className="nav-list-icon">🦄</div>
              <div className="nav-list-info">Discovery</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/items">
            <div className="nav-list-container">
              <div className="nav-list-icon">📚</div>
              <div className="nav-list-info">TL</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/signup">
            <div className="nav-list-container">
              <div className="nav-list-icon">🎞️</div>
              <div className="nav-list-info">TV</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/login">
            <div className="nav-list-container">
              <div className="nav-list-icon">🎉</div>
              <div className="nav-list-info">Notice</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/">
            <div className="nav-list-container">
              <div className="nav-list-icon">📧</div>
              <div className="nav-list-info">DM</div>
            </div>
          </Link>
        </div>
        <div className="nav-li">
          <Link href="/">
            <div className="nav-list-container">
              <div className="nav-list-icon">💖</div>
              <div className="nav-list-info">Me</div>
            </div>
          </Link>
        </div>
      </div>
      <div className="nav-menu">
        <div className="nav-li">
          <Link href="/">
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
        @media (max-width: 400px) {
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
        @media (min-width: 700px) {
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