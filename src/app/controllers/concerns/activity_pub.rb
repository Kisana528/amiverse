module ActivityPub
  def create_note(item)
    {
      "@context": "https://www.w3.org/ns/activitystreams",
      "type": "Create",
      "id": "https://amiverse.net/items/#{item.item_id}/create",
      "published": item.created_at,
      "to": [
        "https://amiverse.net/#{item.account.name_id}/followers",
        "https://www.w3.org/ns/activitystreams#Public"
      ],
      "actor": "https://amiverse.net/#{item.account.name_id}",
      "object": {
        "@context": "https://www.w3.org/ns/activitystreams",
        "type": "Note",
        "id": "https://amiverse.net/items/#{item.item_id}",
        "url": "https://amiverse.net/items/#{item.item_id}",
        "published": item.created_at,
        "to": [
          "https://amiverse.net/#{item.account.name_id}/followers",
          "https://www.w3.org/ns/activitystreams#Public"
        ],
        "attributedTo": "https://amiverse.net/#{item.account.name_id}/followers",
        "content": item.content
      }
    }
  end
  def deliver(body, name_id, private_key, from_url, to_url, public_key)
    headers, digest, to_be_signed, sign = sign_headers(body, name_id, private_key, from_url, to_url)
    req,res = https_post(
      to_url,
      headers,
      body.to_json
    )
    # 検証開始
    result = verify_signature(public_key, to_be_signed, sign)
    Rails.logger.info('-----結果発表------')
    Rails.logger.info(result ? 'ok' : 'ng')
    Rails.logger.info(res.body)
    Rails.logger.info('-----内容は------')
    Rails.logger.info(body.to_json)
    Rails.logger.info('-----署名は------')
    Rails.logger.info(to_be_signed)
    Rails.logger.info(sign)
    Rails.logger.info('-----headersは------')
    Rails.logger.info(headers)
    # 検証終了
    ActivityPubDelivered.create(
      host: to_url,
      digest: digest,
      signature: sign,
      content: body.to_json,
      response: res.body)
  end
  def front_deliver(body, name_id, private_key, from_url, to_url, public_key)
    headers, digest, to_be_signed, sign = sign_headers(body, name_id, private_key, from_url, to_url)
    req,res = http_post(
      'http://front:3000/outbox',
      {Authorization: 'Bearer token-here',
      'Content-Type' => 'application/json'
      },{
      to_url: to_url,
      headers: headers,
      body: body}.to_json
    )
    Rails.logger.info(res.body)
    ActivityPubDelivered.create(
      host: to_url,
      digest: digest,
      signature: sign,
      content: body.to_json,
      response: res.body)
  end
  def sign_headers(body, name_id, private_key, from_url, to_url)
    from_host = URI.parse(from_url).host
    to_host = URI.parse(to_url).host
    current_time = Time.now.utc.httpdate
    digest = Digest::SHA256.base64digest(body.to_json)
    to_be_signed = [
      "(request-target): post /inbox",
      "host: #{to_host}",
      "date: #{current_time}",
      "digest: sha-256=#{digest}",
      "content-type: application/json"].join("\n")
    sign = generate_signature(to_be_signed, private_key)
    statement = [
      "keyId=\"https://#{from_host}/@#{name_id}#main-key\"",
      'algorithm="rsa-sha256"',
      'headers="(request-target) host date digest content-type"',
      "signature=\"#{sign}\""
    ].join(',') # content-lengthも必要?
    headers = {
      Host: to_host,
      Date: current_time,
      Digest: "SHA-256=#{digest}",
      Signature: statement,
      Authorization: "Signature #{statement}",
      Accept: 'application/json',
      #'Accept-Encoding': 'gzip',
      #'Cache-Control': 'max-age=0',
      'Content-Type': 'application/json',
      'User-Agent': "Amiverse v0.0.1 (+https://#{from_host}/)"
    }
    return headers, digest, to_be_signed, sign
  end
end