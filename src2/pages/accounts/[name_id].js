import axios from '@/lib/axios'
import { useContext, useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import {appContext} from '@/pages/_app'
import Link from 'next/link'
import Image from 'next/image'

export default function Account() {
  const loggedIn = useContext(appContext).loggedIn
  const { query = {} } = useRouter()
  const [account, setAccount] = useState({})

  if (process.browser) {
    if(document.getElementById('banner-container')){
      window.addEventListener('scroll', () => {
        let elem = document.getElementById('banner-container')
        let scrollY = window.scrollY/2000 + 1
        if(scrollY > 1.5) scrollY = 1.5
        elem.style.transform = 'scale(' + scrollY + ')'
      })
      const header = document.getElementById('name-container')
      const observer = new IntersectionObserver(entries => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            header.classList.remove('fixed')
          } else {
            header.classList.add('fixed')
          }
        }
      })
      observer.observe(document.getElementById('name-before'))
    }
  }
  useEffect(() => {
    if (query.name_id) {
      axios.post('/api/@'+query.name_id)
      .then(res => {
        setAccount(res.data)
      })
      .catch(err => {
      })
    }
  },[query])

  return (
    <>
      <div className="account-container" id="account-container">
        <div className="top-container">
          <div className="banner-container" id="banner-container" >
            <Link href="/">
            </Link>
          </div>
        </div>
        <div className="name-container" id="name-container">
          <div id="name-before"></div>
          <div className="icon-container">
          </div>
          <div className="meta-container">
            <h1>{ account.name }</h1>
            <div>{ account.name_id }</div>
            {/* フォローボタンor編集ボタン */  }
          </div>
        </div>

        <div className="profile-container">
          <div><span>紹介:</span>{ account.bio }</div>
          <div><span>場所:</span>{ account.location }</div>
          <div><span>誕生日:</span>{ account.birthday }</div>
          <div><span>フォロワー:</span>{ account.followers }</div>
          <div><span>フォロー:</span>{ account.following }</div>
          <div><span>投稿数:</span>{ account.items_count }</div>
          <div><span>参加日:</span>{ account.created_at }</div>
        </div>
        <div className="account-tab-container">
          <div>投稿</div>
          <div>返信</div>
          <div>メディア</div>
          <div>リアクション</div>
        </div>
        <div className="content-container">
          <p>開始</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>ここにコンテンツ</p>
          <p>終了</p>
        </div>
      </div>
      {query.name_id || 'missing'}
      <style jsx="true">{`
        .account-container {
          max-width: 800px;
          margin: auto;
        }
        
        // バナー
        
        .top-container {
          width: 100%;
          aspect-ratio: 1/1;
          position: sticky;
          top: 60px;
          overflow: hidden;
        }
        .banner-container {
          width: 100%;
          aspect-ratio: 1/1;
          position: absolute;
          top: 0px;
          overflow: hidden;
        }
        .account-banner {
          width: 100%;
          aspect-ratio: 1/1;
          object-fit: cover;
          object-position: top center;
          display: block;
        }
        
        // 名前
        
        .name-container {
          height: 104px;
          display: flex;
          background: #dc24a138;
          backdrop-filter: blur(3px);
          border-radius: 10px 10px 0 0;
          //box-shadow: 0 -20px 25px 10px #dc24a138;
          position: sticky;
          top: 59px;
          z-index: 2;
          transition-duration: 0.5s;
          align-items: center;
        }
        #name-before {
          position: absolute;
          left: 0;
          bottom: 165px;
          width: 100%;
        }
        .icon-container {
          
        }
        .icon-container img {
          transition-duration: 0.5s;
        }
        .account-icon {
          width: 100px;
          aspect-ratio: 1/1;
          object-fit: cover;
          object-position: top;
          border: 2px #36f18a solid;
          border-radius: 54px;
          display: block;
        }
        .meta-container {
          
        }
        .meta-container h1 {
          margin: 0;
        }
        // 接着
        .fixed {
          background-color: #000000;
          border-radius: 0;
          height: 54px;
        }
        .fixed .account-icon {
          width: 50px;
        }
        .fixed .meta-container {
          display: flex;
          align-items: center;
        }
        
        // プロフ
        
        .profile-container {
          padding: 10px;
          background: #01153c;
          z-index: 1;
          position: relative;
        }
        .profile-container p {
          margin: 0px;
        }
        
        // タブ
        
        .account-tab-container {
          display: flex;
          border-radius: 0;
          background: #272727;
          overflow-x: scroll;
          //box-shadow: 0 9px 12px 1px #dc24a138;
          z-index: 2;
          position: sticky;
          top: 113px;
          
        }
        .account-tab-container div {
          height: 30px;
          line-height: 30px;
          text-align: center;
        }
        
        // コンテンツ
        
        .content-container {
          background: #000000;
          z-index: 1;
          position: relative;
          padding: 10px;
        }
        
        // 大きさ処理
        
        @media (min-width: 682px) {
          .top-container {
            aspect-ratio: 1/.5;
          }
          .banner-container{
            aspect-ratio: 1/.5;
          }
          .account-banner {
            aspect-ratio: 1/.5;
            object-position: 50% 50%;
          }
        }
        @media (min-aspect-ratio: 4/5) {
          .top-container {
            aspect-ratio: 1/.5;
          }
          .banner-container{
            aspect-ratio: 1/.5;
          }
          .account-banner {
            aspect-ratio: 1/.5;
            object-position: 50% 50%;
          }
        }
        
        // フォーム
        
        .text-field-group {
          position: relative;
          padding: 15px 0 0;
          margin-top: 10px;
          width: 50%;
        }
        .text-field-field {
          width: 100%;
          border: 0;
          border-bottom: 2px solid gray;
          outline: 0;
          font-size: 1.3rem;
          color: white;
          padding: 7px 0;
          background: transparent;
          transition: border-color 0.2s;
          &::placeholder {
            color: transparent;
          }
          &:placeholder-shown ~ .text-field-label {
            cursor: text;
            top: 20px;
          }
        }
        .text-field-label {
          position: absolute;
          top: 0;
          display: block;
          transition: 0.2s;
          color: gray;
        }
        .text-field-field:focus {
          ~ .text-field-label {
            position: absolute;
            top: 0;
            display: block;
            transition: 0.2s;
            color: #6f17a9;
          }
          padding-bottom: 6px;  
          font-weight: 700;
          border-width: 3px;
          border-image: linear-gradient(to right, #3b1183, #6f17a9);
          border-image-slice: 1;
        }
        .text-field-field{
          &:required,&:invalid { box-shadow:none; }
        }
        
        // signup
        
        .signup-container {
          display: flex;
          flex-direction: column;
          align-items: center;
        }
        .signup-form {
          form {
            border: 1px solid;
            width: 400px;
            display: flex;
            align-items: center;
            flex-direction: column;
          }
        }
      `}</style>
    </>
  )
}