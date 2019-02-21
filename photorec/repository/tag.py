class TagRepo:
    """
    Repository for tags that encapsulate access to resources.
    """

    def __init__(self, db):
        self._tags = db.Table('photorec-dynamodb-tags')

    def list(self, limit=None):
        response = self._tags.scan()
        items = response['Items']
        items.sort(reverse=True, key=lambda x: x['score'])
        return items[0:limit]
