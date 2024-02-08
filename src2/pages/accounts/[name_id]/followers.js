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
        accountData = err.data
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
      id: FullAppUrl(`/@${accountData.name_id}`),
      url: FullAppUrl(`/@${accountData.name_id}`),
      tag: [],
      published: accountData.created_at,
      discoverable: true,
      attachment: [],
      manuallyApprovesFollowers: false,
      name: accountData.name,
      summary: "",
      icon: {
        type: 'Image',
        mediaType: 'image/webp',
        url: accountData.icon_url
      },
      preferredUsername: accountData.name_id,
      inbox: FullAppUrl(`/@${accountData.name_id}/inbox`),
      outbox: FullAppUrl(`/@${accountData.name_id}/outbox`),
      followers: FullAppUrl(`/@${accountData.name_id}/followers`),
      following: FullAppUrl(`/@${accountData.name_id}/following`),
      publicKey: {
        id: FullAppUrl(`@${accountData.name_id}#main-key`),
        type: "Key",
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
      </>
    )
  }
}