// Helper functions:
const rawStringToByteArray = (str) => {
  const strLen = str.length;
  var byteArray = new Uint8Array(strLen);
  for (var i = 0; i < strLen; i++) {
    byteArray[i] = str.charCodeAt(i);
  }
  return byteArray;
};
const base64StringToByteArray = (base64) => {
  return rawStringToByteArray(window.atob(base64));
};
const byteArrayToBase64String = (buffer) => {
  var bytes = new Uint8Array(buffer);
  var binary = '';
  for (var i=0; i<bytes.byteLength; i++) {
      binary += String.fromCharCode(bytes[i]);
  }
  return window.btoa(binary);
};

// RemoteTransformer:
const generateAesKey = () => {
  // See http://www.w3.org/TR/WebCryptoAPI/#examples-symmetric-encryption
  return window.crypto.subtle.generateKey({ name: 'AES-CBC', length: 128 },
      false, ['encrypt', 'decrypt']);
};

const createTransformer = (aesKey) => {
  const encode = (record) => {
    const cleartext = rawStringToByteArray(JSON.stringify(record));
    const IV = window.crypto.getRandomValues(new Uint8Array(16));

    return window.crypto.subtle.encrypt({ name: 'AES-CBC', iv: IV }, aesKey,
        cleartext).then(ciphertext => {
      return {
        id: record.id,
        ciphertext: byteArrayToBase64String(new Uint8Array(ciphertext)),
        IV: byteArrayToBase64String(IV)
      };
    });
  };

  const decode = (record) => {
    const ciphertext = base64StringToByteArray(record.ciphertext);
    const IV = base64StringToByteArray(record.IV);

    return crypto.subtle.decrypt({ name: 'AES-CBC', iv: IV }, aesKey,
        ciphertext).then(recordArrayBuffer => {

      return JSON.parse(String.fromCharCode.apply(null,
          new Uint8Array(recordArrayBuffer)));
    }, () => {
      record.undecryptable = true;
      return record;
    }, () => {
      record.undecryptable = true;
      return record;
    });
  };

  return {
    encode,
    decode
  };
};

// Kinto collection:
const createCollection = (transformer, testRun, instanceNo) => {
  const kinto = new Kinto({
    dbPrefix: `${testRun}-${instanceNo}`,
    remote: 'https://kinto.dev.mozaws.net/v1/',
    headers: {
      Authorization: 'Basic ' + btoa('public-demo:s3cr3t')
    }
  });

  return kinto.collection(`kinto-encrypter-les-donnees-${testRun}`, {
    remoteTransformers: [ transformer ]
  });
};

var coll1, coll2;
const prepare = () => {
  return generateAesKey().then(aesKey => {
    return createTransformer(aesKey);
  }).then(transformer => {
    // Create two fresh empty Kinto instances for testing:
    const testRun = new Date().getTime().toString();
    coll1 = createCollection(transformer, testRun, 1);
    coll2 = createCollection(transformer, testRun, 2);
  });
};

const syncUp = () => {
  // Use first Kinto instance to demonstrate encryption:
  return coll1.create({
    URL: 'http://www.w3.org/TR/WebCryptoAPI/',
    name: 'Web Cryptography API'
  }).then(() => {
    return coll1.sync();
  }).then(syncResults => {
    console.log('Sync up', syncResults);
  });
};

const syncDown = () => {
  // Use second Kinto instance to demonstrate decryption:
  return coll2.sync().then(syncResults => {
    console.log('Sync down', syncResults);
  });
};

const go = () => {
  console.log('Watch the Network tab!');
  return prepare().then(() => {
    return syncUp();
  }).then(() => {
    return syncDown();
  }).then(a => console.log('Success', a), b => console.error('Failure', b));
};
