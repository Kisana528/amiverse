import Link from 'next/link'

export default function HeaderText({ children, headerText }) {
  return (
    <>
      <div className="main-header">
        <div className="main-header-text">
          {headerText}
        </div>
      </div>
      <div className="main-container">
        {children}
      </div>
      <style jsx>{`
        .main-header {
          height: 50px;
          width: 100%;
          position: sticky;
          top: 0px;
          display: flex;
          justify-content: space-around;
          align-items: center;
          backdrop-filter: blur(3px);
          background: var(--blur-color);
        }
        .main-header-text {
          background: linear-gradient(90deg, #747eee, #d453cc 50%, #fe5597);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          font-size: 20px;
        }
        .main-container {
          background: var(--main-container-background-color);
          padding: 5px;
        }
      `}</style>
    </>
  )
}