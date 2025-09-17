var config = {
    // list images on console that match no model
    listMissingImages: true,
    // see devices.js for different vendor model maps
    vendormodels: vendormodels,
    // set enabled categories of devices (see devices.js)
    enabled_device_categories: ["recommended"],
    // community prefix of the firmware images
    community_prefix: 'gluon-ffda-',
    // firmware version regex
    version_regex: '-([0-9]+.[0-9]+.[0-9]+([+-~][0-9]+)?)[.-]',
    // relative image paths and branch
    directories: {
        './images/stable/factory/': 'stable',
        './images/stable/sysupgrade/': 'stable',
        './images/stable/other/': 'stable',
        './images/beta/factory/': 'beta',
        './images/beta/sysupgrade/': 'beta',
        './images/beta/other/': 'beta',
        './images/testing/factory/': 'testing',
        './images/testing/sysupgrade/': 'testing',
        './images/testing/other/': 'testing'
    },
    // branch descriptions shown during selection
    branch_descriptions: {
        stable: 'Gut getestet, zuverlässig und stabil.',
        beta: 'Vorabtests neuer Stable-Kandidaten.',
        experimental: 'Ungetestet, automatisch generiert.'
    },
    // recommended branch will be marked during selection
    recommended_branch: 'stable',
    // experimental branches (show a warning for these branches)
    experimental_branches: ['testing'],
    // link to changelog
    changelog: 'https://forum.darmstadt.freifunk.net/c/technik/firmware'
};
