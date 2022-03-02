import { defineUserConfig } from 'vuepress'
import type { DefaultThemeOptions } from 'vuepress'
import type { SidebarConfig } from '@vuepress/theme-default'
import { path } from '@vuepress/utils';

const sidebar: SidebarConfig =  [
  '/intro/',
  '/concepts/',
  '/quick-guides/',
  '/content-api/',
  '/content-api/rest/',
  '/meta-api/',
  '/bagelAuth-api/',
  {
    'text': 'Bagel Auth REST-API',
    link: '/bagelAuth-api/rest/',
  },
  '/examples/',
  ];

export default defineUserConfig<DefaultThemeOptions>({
  lang: 'en-US',
  title: "BagelDB Docs",
  description: "The place to get all the details on BagelDB and how to make the most of it",
  head: [
    ["link", { rel: "icon", type: "image/png", sizes: "32x32", href: "/favicon.png" }]
  ],
  themeConfig: {
    lang: 'en-US',
    logo: "/assets/images/bagel-blue.svg",
    lastUpdated: true,
    navbar: [
      { text: "Home", link: "/" },
      { text: "Examples", link: "/examples/" },
      { text: "Login", link: "https://app.bageldb.com" },
      { text: "Sign Up Now", link: "https://app.bageldb.com/signup" },
      { icon: 'github', link: 'https://github.com/bageldb/' },
      { icon: 'discord', link: 'https://discord.gg/49hq7wu' }
    ],
    sidebar,
  },
  plugins: [
    '@vuepress/plugin-search' //TODO: @vuepress/plugin-docsearch@next
  ],
  bundlerConfig: {  },
  theme: path.resolve(__dirname, './theme'),
  markdown: {

  }
});
