// const endPoint = 'http://43.204.233.46:80';
// const endPoint = 'http://10.0.2.2:4000';
// const endPoint = 'http://localhost:4000';
const endPoint = 'http://192.168.29.15:4000';

/// Queries
const fetchPostQuery = '''
      query {
        getPosts {
          id
          content
          createdBy {
            id
            name
            email
            role
            photoUrl
          }
          dateCreated
          imageUrl
          club {
            id
            name
          }
        }
      }
    ''';

createPostQuery(content, imageUrl, createdBy, dateCreated, club) => '''
      mutation {
        createPost(content: "$content", imageUrl: "$imageUrl", createdBy: "$createdBy", dateCreated: "$dateCreated", club: "$club") {
          id
          content
          imageUrl
          dateCreated
          createdBy {
            id
            name
            email
            role
            photoUrl
          }
          club {
            id
            name
          }
        }
      }
    ''';

updatePostQuery(id, content) => '''
      mutation {
        updatePost(id: "$id", content: "$content") {
          id
          content
          imageUrl
          dateCreated
          createdBy {
            id
            name
            email
            role
            photoUrl
          }
          club {
            id
            name
          }
        }
      }
    ''';

deletePostQuery(id) => '''
      mutation {
        deletePost(id: "$id")
      }
    ''';

getUserQuery(email) => '''
      query {
        getUser(email: "$email") {
          id
          name
          email
          role
          photoUrl
        }
      }
    ''';

createUserQuery(name, email, photoUrl) => '''
      mutation {
        createUser(name: "$name", email: "$email", photoUrl: "$photoUrl") {
         id
         name
         email
         role
         photoUrl
      }
    }
    ''';