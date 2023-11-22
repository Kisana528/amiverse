import axios from '@/lib/axios'
import { useContext, useState, useEffect } from 'react'
import { useRouter } from 'next/router'
import { appContext } from '@/pages/_app'
import Link from 'next/link'
import Image from 'next/image'
import Item from '@/components/item'
import FullAppUrl from '@/components/full_app_url'

export async function getServerSideProps({req, res, context, query}) {
  const accept = req.headers.accept
  // application/activity+jsonが含まれているかチェック
  const isActivity = accept.includes('application/activity+json')
  if(isActivity){
    let accountData = {}
    //問い合わせ
    await axios.post('http://app:3000/v1/@' + query.name_id)
      .then(res => {
        accountData = res.data
      })
      .catch(err => {
        accountData = res.data
      })
    const data = {
      "@context": [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1",
        {
          "manuallyApprovesFollowers": "as:manuallyApprovesFollowers",
          "sensitive": "as:sensitive",
          "Hashtag": "as:Hashtag",
          "quoteUrl": "as:quoteUrl",
          "toot": "http://joinmastodon.org/ns#",
          "Emoji": "toot:Emoji",
          "featured": "toot:featured",
          "discoverable": "toot:discoverable",
          "schema": "http://schema.org#",
          "PropertyValue": "schema:PropertyValue",
          "value": "schema:value",
          "misskey": "https://misskey-hub.net/ns#",
          "_misskey_content": "misskey:_misskey_content",
          "_misskey_quote": "misskey:_misskey_quote",
          "_misskey_reaction": "misskey:_misskey_reaction",
          "_misskey_votes": "misskey:_misskey_votes",
          "isCat": "misskey:isCat",
          "vcard": "http://www.w3.org/2006/vcard/ns#"
        }
      ],
      type: "Person",
      id: FullAppUrl(`@${accountData.name_id}`),
      url: FullAppUrl(`@${accountData.name_id}`),
      tag: [],
      published: accountData.created_at,
      discoverable: true,
      attachment: [],
      manuallyApprovesFollowers: true,
      name: accountData.name,
      summary: "",
      icon: {
        type: 'Image',
        mediaType: 'image/webp',
        url: accountData.icon_url
      },
      preferredUsername: accountData.name_id,
      inbox: FullAppUrl(`@${accountData.name_id}/inbox`),
      outbox: FullAppUrl(`@${accountData.name_id}/outbox`),
      followers: FullAppUrl(`@${accountData.name_id}/followers`),
      following: FullAppUrl(`@${accountData.name_id}/following`),
      publicKey: {
        id: FullAppUrl(`@${accountData.name_id}#main-key`),
        owner: FullAppUrl(`@${accountData.name_id}`),
        publicKeyPem: accountData.public_key
      }
    }

    res.setHeader('Content-Type', 'application/activity+json; charset=utf-8')
    res.write(JSON.stringify(data))
    res.end()
  }
  return {
    props: {
      isActivity
    }
  }
}

export default function Account({ isActivity }) {
  if(!isActivity){
    const loggedIn = useContext(appContext).loggedIn
    const { query = {} } = useRouter()
    const [account, setAccount] = useState({})
    const [items, setItems] = useState([])
    const [scrollY, setScrollY] = useState(1)
    const [fixedHeader, setFixedHeader] = useState(false)
    const [icon, setIcon] = useState('')
    const [banner, setBanner] = useState('')

    if(process.browser){}
    useEffect(() => {
      const handleScroll = () => {
        const newScrollY = window.scrollY / 2000 + 1
        setScrollY(newScrollY > 1.5 ? 1.5 : newScrollY)
      }
      const observer = new IntersectionObserver(entries => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            setFixedHeader(false)
          } else {
            setFixedHeader(true)
          }
        }
      })
      window.addEventListener('scroll', handleScroll)
      observer.observe(document.getElementById('name-before'))
      return () => {
        window.removeEventListener('scroll', handleScroll)
        observer.disconnect()
      }
    }, [])
    useEffect(() => {
      if (query.name_id) {
        axios.post('/@' + query.name_id)
          .then(res => {
            setAccount(res.data)
            setItems(res.data.items)
            setIcon(res.data.icon_url)
            setBanner(res.data.banner_url)

            console.log(account.items.map)
          })
          .catch(err => {
            //アカウント取得例外
          })
      }
    }, [query])

    return (
      <>
        <div className="account-container" id="account-container">
          <div className="top-container">
            <div className="banner-container" id="banner-container" style={{ transform: `scale(${scrollY})` }}>
              <img
                className="account-banner"
                src={banner}
                alt='banner'
              />
            </div>
          </div>
          <div className={`name-container${fixedHeader ? ' fixed' : ''}`} id="name-container">
            <div id="name-before"></div>
            <div className="icon-container">
              <img
                className="account-icon"
                src={icon}
                alt='icon'
              />
            </div>
            <div className="meta-container">
              <h1>{account.name}</h1>
              <div>@{account.name_id}</div>
              {/* フォローボタンor編集ボタン */}
            </div>
          </div>

          <div className="profile-container">
            <div><span>紹介:</span>{account.bio}</div>
            <div><span>場所:</span>{account.location}</div>
            <div><span>誕生日:</span>{account.birthday}</div>
            <div><span>フォロワー:</span>{account.followers}</div>
            <div><span>フォロー:</span>{account.following}</div>
            <div><span>投稿数:</span>{account.items_count}</div>
            <div><span>参加日:</span>{account.created_at}</div>
          </div>
          <div className="account-tab-container">
            <div>投稿</div>
            <div>返信</div>
            <div>メディア</div>
            <div>リアクション</div>
          </div>
          <div className="content-container">
            {isActivity ? <p>含まれている</p> : <p>含まれておりません</p> }
            <p>開始</p>
            {items.map(item => (
              <Item key={item.item_id} item={item} />
            ))}
            <p>終了</p>
          </div>
        </div>
        <style jsx>{`
          .account-container {
            max-width: 800px;
            margin: auto;
          }
          
          // バナー
          
          .top-container {
            width: 100%;
            aspect-ratio: 1/1;
            position: sticky;
            top: 0px;
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
            background: linear-gradient(90deg,#747eee,#d453cc 50%,#fe5597);
          }
          
          // 名前
          
          .name-container {
            height: 104px;
            display: flex;
            background: var(--name-color);
            backdrop-filter: blur(3px);
            //border-radius: 10px 10px 0 0;
            border-bottom: 0.5px solid var(--border-color);
            //box-shadow: 0 -20px 25px 10px #dc24a138;
            position: sticky;
            top: -1px;
            z-index: 3;
            transition-duration: 0.5s;
            align-items: center;
          }
          #name-before {
            position: absolute;
            left: 0;
            bottom: 164px;
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
            background: linear-gradient(90deg,#747eee,#d453cc 50%,#fe5597);
          }
          .meta-container {
            
          }
          .meta-container h1 {
            margin: 0;
          }
          // 接着
          .fixed {
            background:  var(--fixed-name-color);
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
            background: var(--profile-color);
            border-bottom: 0.5px solid var(--border-color);
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
            background: var(--account-tab-color);
            border-bottom: 0.5px solid var(--border-color);
            //overflow-x: scroll;
            //box-shadow: 0 9px 12px 1px #dc24a138;
            z-index: 2;
            position: sticky;
            top: 53px;
            
          }
          .account-tab-container div {
            height: 30px;
            line-height: 30px;
            text-align: center;
          }
          
          // コンテンツ
          
          .content-container {
            background: var(--content-color);
            z-index: 1;
            position: relative;
            padding: 10px;
          }
          
          // 大きさ処理
          /* 画像を左に、右に名前とプロフといったデザインのほうがいい */
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
}