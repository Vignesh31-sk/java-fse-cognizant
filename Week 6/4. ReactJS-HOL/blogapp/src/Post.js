// src/Post.js
import React from 'react';

const Post = ({ title, body }) => {
  return (
    <div className="post" style={{ border: "1px solid #ccc", padding: "10px", margin: "10px 0" }}>
      <h3>{title}</h3>
      <p>{body}</p>
    </div>
  );
};

export default Post;
