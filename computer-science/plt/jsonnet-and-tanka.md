# 无标题

<!--
ID: b14153ec-11be-4d52-b65c-b31cb3c812da
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1487
-->

Json 和 Yaml 是两种常见并且等价的数据格式，但是现在被普遍用作了配置文件。更进一步地，在 Kubernetes 和 Ansible 中都大量使用 yaml 作为基础设施的配置，这时候问题就来了，既然基础设施的配置都变成了代码，那么显然我们就会想着通过代码来生成代码。Helm 和 Ansible Playbook 都采取了模板的方式，然而采用模板是有诸多问题的。

# 采用模板生成 Yaml 的问题

