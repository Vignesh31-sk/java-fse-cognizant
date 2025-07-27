// src/Posts.js
import React, { Component } from 'react';
import Post from './Post';

class Posts extends Component {
  constructor(props) {
    super(props);
    this.state = {
      posts: [],
      hasError: false
    };
  }

  loadPosts = async () => {
    try {
      const response = await fetch('https://jsonplaceholder.typicode.com/posts');
      if (!response.ok) throw new Error('Failed to fetch posts');
      const data = await response.json();
      this.setState({ posts: data });
    } catch (error) {
      this.setState({ hasError: true });
      console.error('Fetch error:', error);
    }
  };

  componentDidMount() {
    this.loadPosts();
  }

  componentDidCatch(error, info) {
    alert('An error occurred while rendering the component.');
    console.error('componentDidCatch:', error, info);
  }

  render() {
    const { posts, hasError } = this.state;

    if (hasError) {
      return <h2 style={{ color: 'red' }}>Something went wrong while loading posts.</h2>;
    }

    return (
      <div>
        <h2>Posts</h2>
        {posts.length > 0 ? (
          posts.map(post => (
            <Post key={post.id} title={post.title} body={post.body} />
          ))
        ) : (
          <p>Loading posts...</p>
        )}
      </div>
    );
  }
}

export default Posts;
