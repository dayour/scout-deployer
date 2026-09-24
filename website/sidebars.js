module.exports = {
  wikiSidebar: [
    'index',
    {
      type: 'category',
      label: 'Architecture',
      collapsed: false,
      items: ['architecture/overview', 'architecture/repositories'],
    },
    {
      type: 'category',
      label: 'Deployment',
      collapsed: false,
      items: ['deployment/configuration', 'deployment/runbook', 'deployment/policies'],
    },
    {
      type: 'category',
      label: 'Identity and access',
      collapsed: false,
      items: ['identity/app-registration', 'identity/provisioning'],
    },
    {
      type: 'category',
      label: 'Operations',
      collapsed: false,
      items: ['operations/verification', 'operations/troubleshooting'],
    },
    {
      type: 'category',
      label: 'Reference',
      collapsed: false,
      items: ['reference/schemas', 'reference/source-artifacts'],
    },
  ],
};
