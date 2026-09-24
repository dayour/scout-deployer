const lightCodeTheme = require('prism-react-renderer').themes.github;
const darkCodeTheme = require('prism-react-renderer').themes.dracula;

const config = {
  title: 'Scout Deployer',
  tagline: 'Deployment, identity, policy, architecture, and operations for Microsoft Scout',
  url: 'https://dayour.github.io',
  baseUrl: '/scout-deployer/',
  organizationName: 'dayour',
  projectName: 'scout-deployer',
  deploymentBranch: 'master',
  onBrokenLinks: 'throw',
  headTags: [
    {
      tagName: 'script',
      attributes: {},
      innerHTML: `(() => {
  const requested = new URLSearchParams(window.location.search).get("clawpilotTheme");
  const param = requested === "dark" || requested === "light" ? requested : null;
  const theme =
    param || (window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");
  if (param) {
    try {
      window.localStorage.setItem("theme", param);
    } catch {}
    document.documentElement.setAttribute("data-theme-choice", param);
  }
  document.documentElement.setAttribute("data-theme", theme);
})();`,
    },
    {
      tagName: 'meta',
      attributes: {
        name: 'description',
        content: 'Production documentation for Scout Deployer architecture, deployment, Entra identity, policy, schemas, verification, and operations.',
      },
    },
  ],
  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: 'throw',
    },
  },
  themes: ['@docusaurus/theme-mermaid'],
  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/dayour/scout-deployer/edit/master/website/',
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
        sitemap: {
          changefreq: 'weekly',
          priority: 0.6,
          ignorePatterns: ['/tags/**'],
          filename: 'sitemap.xml',
        },
      },
    ],
  ],
  themeConfig: {
    colorMode: {
      defaultMode: 'light',
      respectPrefersColorScheme: true,
      disableSwitch: false,
    },
    navbar: {
      title: 'Scout Deployer',
      hideOnScroll: false,
      items: [
        { to: '/', label: 'Wiki', position: 'left' },
        { to: '/deployment/runbook', label: 'Deploy', position: 'left' },
        { to: '/identity/app-registration', label: 'Identity', position: 'left' },
        { to: '/reference/schemas', label: 'Schemas', position: 'left' },
        {
          href: 'https://github.com/dayour/scout-deployer',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            { label: 'Architecture', to: '/architecture/overview' },
            { label: 'Deployment', to: '/deployment/runbook' },
            { label: 'Identity', to: '/identity/app-registration' },
          ],
        },
        {
          title: 'Reference',
          items: [
            { label: 'Schemas', to: '/reference/schemas' },
            { label: 'Troubleshooting', to: '/operations/troubleshooting' },
            { label: 'Source artifacts', to: '/reference/source-artifacts' },
          ],
        },
        {
          title: 'Project',
          items: [
            { label: 'GitHub repository', href: 'https://github.com/dayour/scout-deployer' },
            { label: 'Report an issue', href: 'https://github.com/dayour/scout-deployer/issues' },
          ],
        },
      ],
      copyright: `Copyright ${new Date().getFullYear()} Scout Deployer contributors.`,
    },
    prism: {
      theme: lightCodeTheme,
      darkTheme: darkCodeTheme,
      additionalLanguages: ['bash', 'json', 'powershell'],
    },
    tableOfContents: {
      minHeadingLevel: 2,
      maxHeadingLevel: 4,
    },
  },
};

module.exports = config;
