/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// See https://docusaurus.io/docs/site-config for all the possible
// site configuration options.

// List of projects/orgs using your project for the users page.
const users = [
  {
    caption: 'JohnCoene',
    // You will need to prepend the image path with your baseUrl
    // if it is not '/', like: '/test-site/img/docusaurus.svg'.
    image: '/img/docusaurus.svg',
    infoLink: 'https://john-coene.com',
    pinned: true,
  },
];

const siteConfig = {
  title: '|tʃəːp|', // Title for your website.
  tagline: 'Twitter network visualisation platform',
  url: 'https://chirp.sh', // Your website URL
  baseUrl: '/', // Base URL for your project */
  // For github.io type URLs, you would set the url and baseUrl like:
  //   url: 'https://facebook.github.io',
  //   baseUrl: '/test-site/',

  // Used for publishing and more
  projectName: '|tʃəːp|',
  organizationName: '|tʃəːp|',
  // For top-level user or org sites, the organization is still the same.
  // e.g., for the https://JoelMarcey.github.io site, it would be set like...
  //   organizationName: 'JoelMarcey'

  // For no header links in the top nav bar -> headerLinks: [],
  headerLinks: [
    {doc: 'quick-start', label: 'Docs'},
    {doc: 'deploy', label: 'Deploy'},
    {page: 'faq', label: 'Reference'},
    {blog: true, label: 'Blog'},
  ],

  // If you have users set above, you add it here:
  users,

  /* path to images for header/footer */
  headerIcon: '',
  footerIcon: 'img/chirp.svg',
  favicon: 'img/chirp_favicon.png',

  /* Colors for website */
  colors: {
    primaryColor: '#2196f3',
    secondaryColor: '#666666',
  },

  /* Custom fonts for website */
  /*
  fonts: {
    myFont: [
      "Times New Roman",
      "Serif"
    ],
    myOtherFont: [
      "-apple-system",
      "system-ui"
    ]
  },
  */

  // This copyright info is used in /core/Footer.js and blog RSS/Atom feeds.
  copyright: `Copyright © ${new Date().getFullYear()} |tʃəːp|`,

  highlight: {
    // Highlight.js theme to use for syntax highlighting in code blocks.
    theme: 'mono-blue',
  },

  // Add custom scripts here that would be placed in <script> tags.
  scripts: [
    'https://buttons.github.io/buttons.js',
		'https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.0/clipboard.min.js',
		'https://cdnjs.cloudflare.com/ajax/libs/jscolor/2.0.4/jscolor.min.js',
    '/js/code-block-buttons.js',
  ],
  stylesheets: [
		'https://use.fontawesome.com/releases/v5.7.2/css/all.css',
		'/css/code-block-buttons.css',
		'/css/custom.css'
	],

  // On page navigation for the current documentation page.
  onPageNav: 'separate',
  // No .html extensions for paths.
  cleanUrl: true,

  // Open Graph and Twitter card images.
  ogImage: 'img/docusaurus.png',
  twitterImage: 'img/docusaurus.png',
  algolia: {
    apiKey: 'b5684430eb9d77620f902606babca491',
    indexName: 'chirp',
    algoliaOptions: {},
  },

  // Show documentation's last contributor's name.
  // enableUpdateBy: true,

  // Show documentation's last update time.
  // enableUpdateTime: true,

  // You may provide arbitrary config keys to be used as needed by your
  // template. For example, if you need your repo's URL...
  //   repoUrl: 'https://github.com/facebook/test-site',
};

module.exports = siteConfig;
