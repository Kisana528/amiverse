import Link from 'next/link'

export default function HeaderLess({ children }) {
  return (
    <>
      <div className="main-container">
        {children}
      </div>
      <style jsx>{`
        .main-container {
          background: var(--main-container-background-color);
          padding: 5px;
        }
      `}</style>
    </>
  )
}